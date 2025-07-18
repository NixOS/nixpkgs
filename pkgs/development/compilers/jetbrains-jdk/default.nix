{
  lib,
  stdenv,
  fetchFromGitHub,
  jetbrains,
  jdk,
  git,
  autoconf,
  zip,
  unzip,
  rsync,
  debugBuild ? false,
  withJcef ? true,

  libXdamage,
  libXxf86vm,
  libXrandr,
  libXi,
  libXcursor,
  libXrender,
  libX11,
  libXext,
  libxcb,
  nss,
  nspr,
  libdrm,
  libgbm,
  wayland,
  udev,
  darwin,
}:

assert debugBuild -> withJcef;

let
  arch =
    {
      "aarch64-linux" = "aarch64";
      "x86_64-linux" = "x64";
      "aarch64-darwin" = "aarch64";
      "x86_64-darwin" = "x64";
    }
    .${stdenv.hostPlatform.system};
  cpu = stdenv.hostPlatform.parsed.cpu.name;
  os = if stdenv.isDarwin then "macosx" else "linux";
in
jdk.overrideAttrs (oldAttrs: rec {
  pname = "jetbrains-jdk" + lib.optionalString withJcef "-jcef";
  javaVersion = "21.0.6";
  build = "895.109";
  # To get the new tag:
  # git clone https://github.com/jetbrains/jetbrainsruntime
  # cd jetbrainsruntime
  # git checkout jbr-release-${javaVersion}b${build}
  # git log --simplify-by-decoration --decorate=short --pretty=short | grep "jbr-" --color=never | cut -d "(" -f2 | cut -d ")" -f1 | awk '{print $2}' | sort -t "-" -k 2 -g | tail -n 1 | tr -d ","
  openjdkTag = "jbr-21.0.6+7";
  version = "${javaVersion}-b${build}";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "JetBrainsRuntime";
    rev = "jb${version}";
    hash = "sha256-Neh0PGer4JnNaForBKRlGPLft5cae5GktreyPRNjFCk=";
  };

  BOOT_JDK = jdk.home;
  # run `git log -1 --pretty=%ct` in jdk repo for new value on update
  SOURCE_DATE_EPOCH = 1726275531;

  patches = [ ];

  dontConfigure = true;

  jcefDestName = if stdenv.isDarwin then "jcef_mac" else "jcef_linux_${arch}";

  mkimagesSh =
    if stdenv.isDarwin then
      "./jb/project/tools/mac/scripts/mkimages.sh"
    else
      "./jb/project/tools/linux/scripts/mkimages_${arch}.sh";

  osSpecificPatch =
    if stdenv.isDarwin then
      ''
        sed -i '40i\--with-xcode-path="${darwin.xcode_16_1}" \\' ./jb/project/tools/mac/scripts/mkimages.sh
        # See https://github.com/JetBrains/JetBrainsRuntime/issues/461
        sed \
          -e 's/C_O_FLAG_HIGHEST_JVM="-O3"/C_O_FLAG_HIGHEST_JVM="-O1"/g' \
          -e 's/C_O_FLAG_HIGHEST="-O3"/C_O_FLAG_HIGHEST="-O1"/g' \
          -e 's/C_O_FLAG_HI="-O3"/C_O_FLAG_HI="-O1"/g' \
          -i make/autoconf/flags-cflags.m4
      ''
    else
      "";

  buildPhase =
    ''
      runHook preBuild

      ${lib.optionalString withJcef "cp -r ${jetbrains.jcef} ${jcefDestName}"}

      ${osSpecificPatch}

      configureFlags=$(echo $configureFlags | sed 's/--host=[^ ]*//')
      sed -i "s|STATIC_CONF_ARGS|STATIC_CONF_ARGS \$configureFlags|" ${mkimagesSh}
      sed \
          -e "s/create_image_bundle \"jb/#/" \
          -e "s/echo Creating /exit 0 #/" \
          -i ${mkimagesSh}
      sed \
          -e "s/OPENJDK_TAG=.*/OPENJDK_TAG=${openjdkTag}/" \
          -e "s/SOURCE_DATE_EPOCH=.*//" \
          -e "s/export SOURCE_DATE_EPOCH//" \
          -e "s/date -u -r /date --utc --date=@/" \
          -i jb/project/tools/common/scripts/common.sh

      patchShebangs .
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      export PATH=${darwin.xcode_16_1}/Contents/Developer/usr/bin/:${darwin.xcode_16_1}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/:$PATH
      export MIGCC=${darwin.xcode_16_1}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc
      unset SDKROOT
    ''
    + ''
      ${mkimagesSh} ${build} ${
        if debugBuild then "fd" else (if withJcef then "jcef" else "nomod")
      } ${arch}

      runHook postBuild
    '';

  installPhase =
    let
      buildType = if debugBuild then "fastdebug" else "release";
      debugSuffix = if debugBuild then "-fastdebug" else "";
      jcefSuffix = if debugBuild || !withJcef then "" else "_jcef";
      jbrsdkDir = "jbrsdk${jcefSuffix}-${javaVersion}-${os}-${arch}${debugSuffix}-b${build}";
    in
    (
      if stdenv.isLinux then
        ''
          runHook preInstall

          mv build/${os}-${cpu}-server-${buildType}/images/jdk/man build/${os}-${cpu}-server-${buildType}/images/${jbrsdkDir}
          rm -rf build/${os}-${cpu}-server-${buildType}/images/jdk
          mv build/${os}-${cpu}-server-${buildType}/images/${jbrsdkDir} build/${os}-${cpu}-server-${buildType}/images/jdk
        ''
        + oldAttrs.installPhase
      else
        ''
          # We need to implement the install phase manually because the default jdk is zulu instead of OpenJDK.
          mkdir -p $out/lib

          cp -r build/${os}-${cpu}-server-${buildType}/images/jdk $out/lib/openjdk

          # Remove some broken manpages.
          rm -rf $out/lib/openjdk/man/ja*

          # Mirror some stuff in top-level.
          mkdir -p $out/share
          ln -s $out/lib/openjdk/include $out/include
          ln -s $out/lib/openjdk/man $out/share/man
          ln -s $out/lib/openjdk/lib/src.zip $out/lib/src.zip
          ln -s $out/include/linux/*_md.h $out/include/
          ln -s $out/lib/openjdk/bin $out/bin
        ''
    )
    + "runHook postInstall";

  # This is only available on Linux https://github.com/JetBrains/JetBrainsRuntime/releases/tag/jbr-release-21.0.6b631.42
  postInstall = lib.optionalString (withJcef && stdenv.isLinux) ''
    chmod +x $out/lib/openjdk/lib/chrome-sandbox
  '';

  dontStrip = debugBuild;

  postFixup = ''
    # Build the set of output library directories to rpath against
    LIBDIRS="${
      lib.makeLibraryPath (
        [
          libXdamage
          libXxf86vm
          libXrandr
          libXi
          libXcursor
          libXrender
          libX11
          libXext
          libxcb
          nss
          nspr
          wayland
        ]
        ++ lib.optionals stdenv.isLinux [
          libgbm
          libdrm
          udev
        ]
      )
    }"
    for output in $outputs; do
      if [ "$output" = debug ]; then continue; fi
      LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \+ | sort -u | tr '\n' ':'):$LIBDIRS"
    done
    # Add the local library paths to remove dependencies on the bootstrap
    for output in $outputs; do
      if [ "$output" = debug ]; then continue; fi
      OUTPUTDIR=$(eval echo \$$output)
      BINLIBS=$(find $OUTPUTDIR/bin/ -type f; find $OUTPUTDIR -name \*.so\*)
      echo "$BINLIBS" | while read i; do
        patchelf --set-rpath "$LIBDIRS:$(patchelf --print-rpath "$i")" "$i" || true
        patchelf --shrink-rpath "$i" || true
      done
    done
  '';

  nativeBuildInputs =
    [
      git
      autoconf
      zip
      unzip
      rsync
    ]
    ++ oldAttrs.nativeBuildInputs
    ++ lib.optionals stdenv.isDarwin [
      darwin.bootstrap_cmds
      darwin.xattr
      darwin.stubs.setfile
      darwin.xcode_16_1
    ];

  meta = with lib; {
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
    inherit (jdk.meta) license platforms mainProgram;
    maintainers = with maintainers; [
      edwtjo
      aoli-al
    ];
  };

  passthru = oldAttrs.passthru // {
    home = "${jetbrains.jdk}/lib/openjdk";
  };
})
