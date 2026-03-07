{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk,
  git,
  autoconf,
  unzip,
  rsync,
  shaderc,
  vulkan-headers,
  libxdamage,
  libxxf86vm,
  libxrandr,
  libxi,
  libxcursor,
  libxrender,
  libx11,
  libxext,
  libxkbcommon,
  libxcb,
  nss,
  nspr,
  libdrm,
  libgbm,
  wayland,
  udev,
  fontconfig,
  darwin,
  debugBuild ? false,
  withJcef ? true,
}:

{
  javaVersion,
  build,
  sourceDateEpoch,
  srcHash,
  jcefPackage ? null,
  xcodePackage,
  extraBuildPhase ? "",
  vendorVersionString ? null,
  extraConfigureFlags ? [ ],
  extraNativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
}:

assert debugBuild -> withJcef;

let
  arch =
    {
      "aarch64-linux" = "aarch64";
      "x86_64-linux" = "x64";
      "aarch64-darwin" = "aarch64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  cpu = stdenv.hostPlatform.parsed.cpu.name;
  version = "${javaVersion}-b${build}";
  openjdkTag = "jbr-release-${javaVersion}b${build}";

  jcefDestName = if stdenv.hostPlatform.isDarwin then "jcef_mac" else "jcef_linux_${arch}";
  mkimagesSh =
    if stdenv.hostPlatform.isDarwin then
      "./jb/project/tools/mac/scripts/mkimages.sh"
    else
      "./jb/project/tools/linux/scripts/mkimages_${arch}.sh";
in
jdk.overrideAttrs (oldAttrs: {
  pname = "jetbrains-jdk" + lib.optionalString withJcef "-jcef";
  inherit
    javaVersion
    build
    version
    openjdkTag
    ;

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "JetBrainsRuntime";
    rev = "jb${version}";
    hash = srcHash;
  };

  env = (oldAttrs.env or { }) // {
    BOOT_JDK = jdk.home;
    # run `git log -1 --pretty=%ct` in jdk repo for new value on update
    SOURCE_DATE_EPOCH = sourceDateEpoch;
  };

  patches = [ ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '40i\--with-xcode-path="${xcodePackage}" \\' ./jb/project/tools/mac/scripts/mkimages.sh
    # See https://github.com/JetBrains/JetBrainsRuntime/issues/461
    sed \
      -e 's/C_O_FLAG_HIGHEST_JVM="-O3"/C_O_FLAG_HIGHEST_JVM="-O1"/g' \
      -e 's/C_O_FLAG_HIGHEST="-O3"/C_O_FLAG_HIGHEST="-O1"/g' \
      -e 's/C_O_FLAG_HI="-O3"/C_O_FLAG_HI="-O1"/g' \
      -i make/autoconf/flags-cflags.m4
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    ${lib.optionalString withJcef "cp -r ${jcefPackage} ${jcefDestName}"}
    ${extraBuildPhase}

    sed \
        -e "s/OPENJDK_TAG=.*/OPENJDK_TAG=${openjdkTag}/" \
        -e "s/SOURCE_DATE_EPOCH=.*//" \
        -e "s/export SOURCE_DATE_EPOCH//" \
        -i jb/project/tools/common/scripts/common.sh

    declare -a realConfigureFlags

    for configureFlag in "''${configureFlags[@]}"; do
      case "$configureFlag" in
        --host=*)
          # intentionally omit flag
          ;;
        ${lib.optionalString (vendorVersionString != null) ''
          --with-vendor-version-string=*)
            # Replace the flag from the JDK to include that it is JBR and the package version, so it passes the installation tests
            realConfigureFlags+=('--with-vendor-version-string="${vendorVersionString}"')
            ;;
        ''}
        *)
          realConfigureFlags+=("$configureFlag")
          ;;
      esac
    done

    ${lib.concatMapStringsSep "\n" (flag: ''realConfigureFlags+=("${flag}")'') extraConfigureFlags}

    echo "computed configure flags: ''${realConfigureFlags[*]}"
    substituteInPlace ${mkimagesSh} --replace-fail "STATIC_CONF_ARGS" "STATIC_CONF_ARGS ''${realConfigureFlags[*]}"

    sed \
        -e "s/create_image_bundle \"jb/#/" \
        -e "s/echo Creating /exit 0 #/" \
        -i ${mkimagesSh}

    patchShebangs .
    ${mkimagesSh} ${build} ${if debugBuild then "fd" else (if withJcef then "jcef" else "nomod")}

    runHook postBuild
  '';

  installPhase =
    let
      buildType = if debugBuild then "fastdebug" else "release";
      debugSuffix = if debugBuild then "-fastdebug" else "";
      jcefSuffix = if debugBuild || !withJcef then "" else "_jcef";
      jbrsdkDir = "jbrsdk${jcefSuffix}-${javaVersion}-linux-${arch}${debugSuffix}-b${build}";
      os = if stdenv.hostPlatform.isDarwin then "macosx" else "linux";
    in
    ''
      runHook preInstall

      mv build/${os}-${cpu}-server-${buildType}/images/jdk/man build/${os}-${cpu}-server-${buildType}/images/${jbrsdkDir}
      rm -rf build/${os}-${cpu}-server-${buildType}/images/jdk
      mv build/${os}-${cpu}-server-${buildType}/images/${jbrsdkDir} build/${os}-${cpu}-server-${buildType}/images/jdk
    ''
    + oldAttrs.installPhase
    + "runHook postInstall";

  postInstall = lib.optionalString (withJcef && stdenv.hostPlatform.isLinux) ''
    chmod +x $out/lib/openjdk/lib/chrome-sandbox
  '';

  dontStrip = debugBuild;

  postFixup = ''
    # Build the set of output library directories to rpath against
    LIBDIRS="${
      lib.makeLibraryPath (
        [
          libxdamage
          libxxf86vm
          libxrandr
          libxi
          libxcursor
          libxrender
          libx11
          libxext
          libxkbcommon
          libxcb
          nss
          nspr
          fontconfig
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          udev
          libgbm
          libdrm
          wayland
        ]
      )
    }"
    for output in ${lib.concatStringsSep " " oldAttrs.outputs}; do
      if [ "$output" = debug ]; then continue; fi
      LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \+ | sort -u | tr '\n' ':'):$LIBDIRS"
    done
    # Add the local library paths and drop rpath entries pointing at the
    # boot JDK
    for output in ${lib.concatStringsSep " " oldAttrs.outputs}; do
      if [ "$output" = debug ]; then continue; fi
      OUTPUTDIR=$(eval echo \$$output)
      BINLIBS=$(find $OUTPUTDIR/bin/ -type f; find $OUTPUTDIR -name \*.so\*)
      echo "$BINLIBS" | while read i; do
        OLD_RPATH="$(patchelf --print-rpath "$i" 2>/dev/null | tr ':' '\n' | grep -v "^${jdk}" | tr '\n' ':')" || true
        patchelf --set-rpath "$LIBDIRS:''${OLD_RPATH%:}" "$i" || true
      done
    done
  '';

  nativeBuildInputs = [
    git
    autoconf
    unzip
    rsync
    shaderc # glslc
  ]
  ++ extraNativeBuildInputs
  ++ oldAttrs.nativeBuildInputs
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.bootstrap_cmds
    darwin.xattr
    xcodePackage
  ];

  buildInputs = [
    vulkan-headers
  ]
  ++ extraBuildInputs
  ++ oldAttrs.buildInputs or [ ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.bootstrap_cmds
    darwin.xattr
    xcodePackage
  ];

  meta = {
    description = "OpenJDK fork to better support Jetbrains's products";
    longDescription = ''
      JetBrains Runtime is a runtime environment for running IntelliJ Platform
      based products on Windows, Mac OS X, and Linux. JetBrains Runtime is
      based on OpenJDK project with some modifications. These modifications
      include: Subpixel Anti-Aliasing, enhanced font rendering on Linux, HiDPI
      support, ligatures, some fixes for native crashes not presented in
      official build, and other small enhancements.
      JetBrains Runtime is not a certified build of OpenJDK. Please, use at
      your own risk.
    '';
    homepage = "https://confluence.jetbrains.com/display/JBR/JetBrains+Runtime";
    inherit (jdk.meta) license mainProgram;
    maintainers = with lib.maintainers; [
      aoli-al
      eveeifyeve # Darwin
    ];

    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
