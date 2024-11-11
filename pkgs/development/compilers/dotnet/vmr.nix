{
  clangStdenv,
  lib,
  fetchurl,
  dotnetCorePackages,
  jq,
  curl,
  git,
  cmake,
  pkg-config,
  llvm,
  zlib,
  icu,
  lttng-ust_2_12,
  krb5,
  glibcLocales,
  ensureNewerSourcesForZipFilesHook,
  darwin,
  xcbuild,
  swiftPackages,
  openssl,
  getconf,
  python3,
  xmlstarlet,
  nodejs,
  callPackage,
  unzip,
  yq,

  bootstrapSdk,
  releaseManifestFile,
  tarballHash,
}:

let
  stdenv = if clangStdenv.hostPlatform.isDarwin then swiftPackages.stdenv else clangStdenv;

  inherit (stdenv)
    isLinux
    isDarwin
    buildPlatform
    targetPlatform
    ;
  inherit (swiftPackages) apple_sdk swift;

  releaseManifest = lib.importJSON releaseManifestFile;
  inherit (releaseManifest) release sourceRepository tag;

  buildRid = dotnetCorePackages.systemToDotnetRid buildPlatform.system;
  targetRid = dotnetCorePackages.systemToDotnetRid targetPlatform.system;
  targetArch = lib.elemAt (lib.splitString "-" targetRid) 1;

  sigtool = callPackage ./sigtool.nix { };

  _icu = if isDarwin then darwin.ICU else icu;

in
stdenv.mkDerivation rec {
  pname = "dotnet-vmr";
  version = release;

  # TODO: fix this in the binary sdk packages
  preHook = lib.optionalString stdenv.hostPlatform.isDarwin ''
    addToSearchPath DYLD_LIBRARY_PATH "${_icu}/lib"
    export DYLD_LIBRARY_PATH
  '';

  src = fetchurl {
    url = "${sourceRepository}/archive/refs/tags/${tag}.tar.gz";
    hash = tarballHash;
  };

  nativeBuildInputs =
    [
      ensureNewerSourcesForZipFilesHook
      jq
      curl.bin
      git
      cmake
      pkg-config
      python3
      xmlstarlet
      unzip
      yq
    ]
    ++ lib.optionals (lib.versionAtLeast version "9") [
      nodejs
    ]
    ++ lib.optionals isDarwin [
      getconf
    ];

  buildInputs =
    [
      # this gets copied into the tree, but we still want the hooks to run
      bootstrapSdk
      # the propagated build inputs in llvm.dev break swift compilation
      llvm.out
      zlib
      _icu
      openssl
    ]
    ++ lib.optionals isLinux [
      krb5
      lttng-ust_2_12
    ]
    ++ lib.optionals isDarwin (
      with apple_sdk.frameworks;
      [
        xcbuild
        swift
        (krb5.overrideAttrs (old: {
          # the propagated build inputs break swift compilation
          buildInputs = old.buildInputs ++ old.propagatedBuildInputs;
          propagatedBuildInputs = [ ];
        }))
        sigtool
        Foundation
        CoreFoundation
        CryptoKit
        System
      ]
      ++ lib.optional (lib.versionAtLeast version "9") GSS
    );

  # This is required to fix the error:
  # > CSSM_ModuleLoad(): One or more parameters passed to a function were not valid.
  # The error occurs during
  # AppleCryptoNative_X509ImportCollection -> ReadX509 -> SecItemImport
  # while importing trustedroots/codesignctl.pem. This happens during any dotnet
  # restore operation.
  # Enabling com.apple.system.opendirectoryd.membership causes swiftc to use
  # /var/folders for its default cache path, so the swiftc -module-cache-path
  # patch below is required.
  sandboxProfile = ''
    (allow file-read* (subpath "/private/var/db/mds/system"))
    (allow mach-lookup (global-name "com.apple.SecurityServer")
                       (global-name "com.apple.system.opendirectoryd.membership"))
  '';

  patches =
    lib.optionals (lib.versionAtLeast version "9") [
      ./UpdateNuGetConfigPackageSourcesMappings-don-t-add-em.patch
    ]
    ++ lib.optionals (lib.versionOlder version "9") [
      ./fix-aspnetcore-portable-build.patch
    ];

  postPatch =
    ''
      # set the sdk version in global.json to match the bootstrap sdk
      jq '(.tools.dotnet=$dotnet)' global.json --arg dotnet "$(${bootstrapSdk}/bin/dotnet --version)" > global.json~
      mv global.json{~,}

      patchShebangs $(find -name \*.sh -type f -executable)

      # I'm not sure why this is required, but these files seem to use the wrong
      # property name.
      # TODO: not needed in 9.0?
      [[ ! -f src/xliff-tasks/eng/Versions.props ]] || \
        sed -i 's:\bVersionBase\b:VersionPrefix:g' \
          src/xliff-tasks/eng/Versions.props

      # at least in 9.0 preview 1, this package depends on a specific beta build
      # of System.CommandLine
      xmlstarlet ed \
        --inplace \
        -s //Project -t elem -n PropertyGroup \
        -s \$prev -t elem -n NoWarn -v '$(NoWarn);NU1603' \
        src/nuget-client/src/NuGet.Core/NuGet.CommandLine.XPlat/NuGet.CommandLine.XPlat.csproj

      # AD0001 crashes intermittently in source-build-reference-packages with
      # CSC : error AD0001: Analyzer 'Microsoft.NetCore.CSharp.Analyzers.Runtime.CSharpDetectPreviewFeatureAnalyzer' threw an exception of type 'System.NullReferenceException' with message 'Object reference not set to an instance of an object.'.
      # possibly related to https://github.com/dotnet/runtime/issues/90356
      xmlstarlet ed \
        --inplace \
        -s //Project -t elem -n PropertyGroup \
        -s \$prev -t elem -n NoWarn -v '$(NoWarn);AD0001' \
        src/source-build-reference-packages/src/referencePackages/Directory.Build.props

      # https://github.com/microsoft/ApplicationInsights-dotnet/issues/2848
      xmlstarlet ed \
        --inplace \
        -u //_:Project/_:PropertyGroup/_:BuildNumber -v 0 \
        src/source-build-externals/src/application-insights/.props/_GlobalStaticVersion.props

      # this fixes compile errors with clang 15 (e.g. darwin)
      substituteInPlace \
        src/runtime/src/native/libs/CMakeLists.txt \
        --replace-fail 'add_compile_options(-Weverything)' 'add_compile_options(-Wall)'

      # strip native symbols in runtime
      # see: https://github.com/dotnet/source-build/issues/2543
      xmlstarlet ed \
        --inplace \
        -s //Project -t elem -n PropertyGroup \
        -s \$prev -t elem -n KeepNativeSymbols -v false \
        src/runtime/Directory.Build.props
    ''
    + lib.optionalString (lib.versionAtLeast version "9") ''
      # repro.csproj fails to restore due to missing freebsd packages
      xmlstarlet ed \
        --inplace \
        -s //Project -t elem -n PropertyGroup \
        -s \$prev -t elem -n RuntimeIdentifiers -v ${targetRid} \
        src/runtime/src/coreclr/tools/aot/ILCompiler/repro/repro.csproj

      # https://github.com/dotnet/runtime/pull/98559#issuecomment-1965338627
      xmlstarlet ed \
        --inplace \
        -s //Project -t elem -n PropertyGroup \
        -s \$prev -t elem -n NoWarn -v '$(NoWarn);CS9216' \
        src/runtime/Directory.Build.props

      # patch packages installed from npm cache
      xmlstarlet ed \
        --inplace \
        -s //Project -t elem -n Import \
        -i \$prev -t attr -n Project -v "${./patch-npm-packages.proj}" \
        src/aspnetcore/eng/DotNetBuild.props
    ''
    + lib.optionalString (lib.versionAtLeast version "9") ''
      # https://github.com/dotnet/source-build/issues/3131#issuecomment-2030215805
      substituteInPlace \
        src/aspnetcore/eng/Dependencies.props \
        --replace-fail \
        "'\$(DotNetBuildSourceOnly)' == 'true'" \
        "'\$(DotNetBuildSourceOnly)' == 'true' and \$(PortableBuild) == 'false'"

      # https://github.com/dotnet/source-build/issues/4325
      xmlstarlet ed \
        --inplace \
        -r '//Target[@Name="UnpackTarballs"]/Move' -v Copy \
        eng/init-source-only.proj

      # error: _FORTIFY_SOURCE requires compiling with optimization (-O) [-Werror,-W#warnings]
      substituteInPlace \
        src/runtime/src/coreclr/ilasm/CMakeLists.txt \
        --replace-fail 'set_source_files_properties( prebuilt/asmparse.cpp PROPERTIES COMPILE_FLAGS "-O0" )' ""

      # https://github.com/dotnet/source-build/issues/4444
      xmlstarlet ed \
        --inplace \
        -s '//Project/Target/MSBuild[@Targets="Restore"]' \
        -t attr -n Properties -v "NUGET_PACKAGES='\$(CurrentRepoSourceBuildPackageCache)'" \
        src/aspnetcore/eng/Tools.props
    ''
    + lib.optionalString isLinux (
      ''
        substituteInPlace \
          src/runtime/src/native/libs/System.Security.Cryptography.Native/opensslshim.c \
          --replace-fail '"libssl.so"' '"${openssl.out}/lib/libssl.so"'

        substituteInPlace \
          src/runtime/src/native/libs/System.Net.Security.Native/pal_gssapi.c \
          --replace-fail '"libgssapi_krb5.so.2"' '"${lib.getLib krb5}/lib/libgssapi_krb5.so.2"'

        substituteInPlace \
          src/runtime/src/native/libs/System.Globalization.Native/pal_icushim.c \
          --replace-fail '"libicui18n.so"' '"${icu}/lib/libicui18n.so"' \
          --replace-fail '"libicuuc.so"' '"${icu}/lib/libicuuc.so"'
      ''
      + lib.optionalString (lib.versionAtLeast version "9") ''
        substituteInPlace \
          src/runtime/src/native/libs/System.Globalization.Native/pal_icushim.c \
          --replace-fail '#define VERSIONED_LIB_NAME_LEN 64' '#define VERSIONED_LIB_NAME_LEN 256'
      ''
      + lib.optionalString (lib.versionOlder version "9") ''
        substituteInPlace \
          src/runtime/src/native/libs/System.Globalization.Native/pal_icushim.c \
          --replace-warn 'libicuucName[64]' 'libicuucName[256]' \
          --replace-warn 'libicui18nName[64]' 'libicui18nName[256]'
      ''
    )
    + lib.optionalString isDarwin (
      ''
        substituteInPlace \
          src/runtime/src/native/libs/System.Globalization.Native/CMakeLists.txt \
          --replace-fail '/usr/lib/libicucore.dylib' '${darwin.ICU}/lib/libicucore.dylib'

        substituteInPlace \
          src/runtime/src/installer/managed/Microsoft.NET.HostModel/HostModelUtils.cs \
          src/sdk/src/Tasks/Microsoft.NET.Build.Tasks/targets/Microsoft.NET.Sdk.targets \
          --replace-fail '/usr/bin/codesign' '${sigtool}/bin/codesign'

        # fix: strip: error: unknown argument '-n'
        substituteInPlace \
          src/runtime/eng/native/functions.cmake \
          --replace-fail ' -no_code_signature_warning' ""

        # [...]/installer.singlerid.targets(434,5): error MSB3073: The command "pkgbuild [...]" exited with code 127
        xmlstarlet ed \
          --inplace \
          -s //Project -t elem -n PropertyGroup \
          -s \$prev -t elem -n SkipInstallerBuild -v true \
          src/runtime/Directory.Build.props

        # stop passing -sdk without a path
        # stop using xcrun
        # add -module-cache-path to fix swift errors, see sandboxProfile
        # <unknown>:0: error: unable to open output file '/var/folders/[...]/C/clang/ModuleCache/[...]/SwiftShims-[...].pcm': 'Operation not permitted'
        # <unknown>:0: error: could not build Objective-C module 'SwiftShims'
        substituteInPlace \
          src/runtime/src/native/libs/System.Security.Cryptography.Native.Apple/CMakeLists.txt \
          --replace-fail ' -sdk ''${CMAKE_OSX_SYSROOT}' "" \
          --replace-fail 'xcrun swiftc' 'swiftc -module-cache-path "$ENV{HOME}/.cache/module-cache"'
      ''
      + lib.optionalString (lib.versionAtLeast version "9") ''
        # fix: strip: error: unknown argument '-n'
        substituteInPlace \
          src/runtime/src/coreclr/nativeaot/BuildIntegration/Microsoft.NETCore.Native.targets \
          src/runtime/src/native/managed/native-library.targets \
          --replace-fail ' -no_code_signature_warning' ""

        # ld: library not found for -ld_classic
        substituteInPlace \
          src/runtime/src/coreclr/nativeaot/BuildIntegration/Microsoft.NETCore.Native.Unix.targets \
          src/runtime/src/coreclr/tools/aot/ILCompiler/ILCompiler.csproj \
          --replace-fail 'Include="-ld_classic"' ""
      ''
      + lib.optionalString (lib.versionOlder version "9") ''
        # [...]/build.proj(123,5): error : Did not find PDBs for the following SDK files:
        # [...]/build.proj(123,5): error : sdk/8.0.102/System.Resources.Extensions.dll
        # [...]/build.proj(123,5): error : sdk/8.0.102/System.CodeDom.dll
        # [...]/build.proj(123,5): error : sdk/8.0.102/FSharp/System.Resources.Extensions.dll
        # [...]/build.proj(123,5): error : sdk/8.0.102/FSharp/System.CodeDom.dll
        substituteInPlace \
          build.proj \
          --replace-fail 'FailOnMissingPDBs="true"' 'FailOnMissingPDBs="false"'

        substituteInPlace \
          src/runtime/src/mono/CMakeLists.txt \
          --replace-fail '/usr/lib/libicucore.dylib' '${darwin.ICU}/lib/libicucore.dylib'
      ''
    );

  prepFlags = [
    "--no-artifacts"
    "--no-prebuilts"
    "--with-packages"
    bootstrapSdk.artifacts
  ];

  configurePhase =
    let
      prepScript = if (lib.versionAtLeast version "9") then "./prep-source-build.sh" else "./prep.sh";
    in
    ''
      runHook preConfigure

      # The build process tries to overwrite some things in the sdk (e.g.
      # SourceBuild.MSBuildSdkResolver.dll), so it needs to be mutable.
      cp -Tr ${bootstrapSdk} .dotnet
      chmod -R +w .dotnet

      ${prepScript} $prepFlags

      runHook postConfigure
    '';

  postConfigure = lib.optionalString (lib.versionAtLeast version "9") ''
    # see patch-npm-packages.proj
    typeset -f isScript patchShebangs > src/aspnetcore/patch-shebangs.sh
  '';

  dontConfigureNuget = true; # NUGET_PACKAGES breaks the build
  dontUseCmakeConfigure = true;

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  LOCALE_ARCHIVE = lib.optionalString isLinux "${glibcLocales}/lib/locale/locale-archive";

  buildFlags =
    [
      "--with-packages"
      bootstrapSdk.artifacts
      "--clean-while-building"
      "--release-manifest"
      releaseManifestFile
    ]
    ++ lib.optionals (lib.versionAtLeast version "9") [
      "--source-build"
    ]
    ++ [
      "--"
      "-p:PortableBuild=true"
    ]
    ++ lib.optional (targetRid != buildRid) "-p:TargetRid=${targetRid}";

  buildPhase = ''
    runHook preBuild

    # on darwin, in a sandbox, this causes:
    # CSSM_ModuleLoad(): One or more parameters passed to a function were not valid.
    export DOTNET_GENERATE_ASPNET_CERTIFICATE=0

    # CLR_CC/CXX need to be set to stop the build system from using clang-11,
    # which is unwrapped
    # dotnet needs to be in PATH to fix:
    # src/sdk/eng/restore-toolset.sh: line 114: /nix/store/[...]-dotnet-sdk-9.0.100-preview.2.24157.14//.version: Read-only file system
    version= \
    CLR_CC=$(command -v clang) \
    CLR_CXX=$(command -v clang++) \
    PATH=$PWD/.dotnet:$PATH \
      ./build.sh $buildFlags

    runHook postBuild
  '';

  installPhase =
    let
      assets = if (lib.versionAtLeast version "9") then "assets" else targetArch;
    in
    ''
      runHook preInstall

      mkdir "$out"

      pushd "artifacts/${assets}/Release"
      find . -name \*.tar.gz | while read archive; do
        target=$out/$(basename "$archive" .tar.gz)
        # dotnet 9 currently has two copies of the sdk tarball
        [[ ! -e "$target" ]] || continue
        mkdir "$target"
        tar -C "$target" -xzf "$PWD/$archive"
      done
      popd

      local -r unpacked="$PWD/.unpacked"
      for nupkg in $out/Private.SourceBuilt.Artifacts.*.${targetRid}/{,SourceBuildReferencePackages/}*.nupkg; do
          rm -rf "$unpacked"
          unzip -qd "$unpacked" "$nupkg"
          chmod -R +rw "$unpacked"
          rm "$nupkg"
          mv "$unpacked" "$nupkg"
          # TODO: should we fix executable flags here? see dotnetInstallHook
      done

      runHook postInstall
    '';

  # dotnet cli is in the root, so we need to strip from there
  # TODO: should we install in $out/share/dotnet?
  stripDebugList = [ "." ];
  # stripping dlls results in:
  # Failed to load System.Private.CoreLib.dll (error code 0x8007000B)
  # stripped crossgen2 results in:
  # Failure processing application bundle; possible file corruption.
  # this needs to be a bash array
  preFixup = ''
    stripExclude=(\*.dll crossgen2)
  '';

  passthru = {
    inherit releaseManifest buildRid targetRid;
    icu = _icu;
    # ilcompiler is currently broken: https://github.com/dotnet/source-build/issues/1215
    hasILCompiler = lib.versionAtLeast version "9";
  };

  meta = with lib; {
    description = "Core functionality needed to create .NET Core projects, that is shared between Visual Studio and CLI";
    homepage = "https://dotnet.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ corngood ];
    mainProgram = "dotnet";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
