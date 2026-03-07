{
  lib,
  stdenv,
  fetchFromGitHub,
  jetbrains,
  jdk,
  git,
  autoconf,
  unzip,
  rsync,
  debugBuild ? false,
  withJcef ? true,

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
  shaderc,
  vulkan-headers,
  darwin,
}:

assert debugBuild -> withJcef;

let
  arch =
    {
      "aarch64-linux" = "aarch64";
      "x86_64-linux" = "x64";
      "aarch64-darwin" = "aarch64";
      #TODO: 26.11: remove the support for x86_64-darwin for more info please see: https://github.com/NixOS/nixpkgs/pull/492160
      "x86_64-darwin" = "x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  cpu = stdenv.hostPlatform.parsed.cpu.name;
  os = if stdenv.isDarwin then "macosx" else "linux";
in
jdk.overrideAttrs (oldAttrs: rec {
  pname = "jetbrains-jdk" + lib.optionalString withJcef "-jcef";
  javaVersion = "21.0.9";
  build = "1163.86";
  # To get the new tag:
  # git clone https://github.com/jetbrains/jetbrainsruntime
  # cd jetbrainsruntime
  # git tag --points-at [revision]
  # Look for the line that starts with jbr-
  openjdkTag = "jbr-release-21.0.9b1163.86";
  version = "${javaVersion}-b${build}";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "JetBrainsRuntime";
    rev = "jb${version}";
    hash = "sha256-P2boCbGB66X8LB4sZHGFO8lqHbv6F4kqGVMGBd9yKu0=";
  };

  env = (oldAttrs.env or { }) // {
    BOOT_JDK = jdk.home;
    # run `git log -1 --pretty=%ct` in jdk repo for new value on update
    SOURCE_DATE_EPOCH = 1765114563;
  };

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

  buildPhase = ''
    runHook preBuild

    ${lib.optionalString withJcef "cp -r ${jetbrains.jcef} ${jcefDestName}"}

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
        *)
          realConfigureFlags+=("$configureFlag")
          ;;
      esac
    done
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
    in
    (
      if stdenv.hostPlatform.isLinux then
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
        ++ lib.optionals stdenv.isLinux [
          wayland
          libgbm
          libdrm
          udev
        ]
      )
    }"
    for output in ${lib.concatStringsSep " " oldAttrs.outputs}; do
      if [ "$output" = debug ]; then continue; fi
      LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \+ | sort -u | tr '\n' ':'):$LIBDIRS"
    done
    # Add the local library paths to remove dependencies on the bootstrap
    for output in ${lib.concatStringsSep " " oldAttrs.outputs}; do
      if [ "$output" = debug ]; then continue; fi
      OUTPUTDIR=$(eval echo \$$output)
      BINLIBS=$(find $OUTPUTDIR/bin/ -type f; find $OUTPUTDIR -name \*.so\*)
      echo "$BINLIBS" | while read i; do
        patchelf --set-rpath "$LIBDIRS:$(patchelf --print-rpath "$i")" "$i" || true
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
  ++ oldAttrs.nativeBuildInputs
  ++ lib.optionals stdenv.isDarwin [
    darwin.bootstrap_cmds
    darwin.xcode_16_1
    darwin.xattr
  ];

  buildInputs = [
    vulkan-headers
  ]
  ++ oldAttrs.buildInputs or [ ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.bootstrap_cmds
    darwin.xattr
    darwin.xcode_16_1
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
    inherit (jdk.meta) license platforms mainProgram;
    maintainers = with lib.maintainers; [
      aoli-al
      eveeifyeve # Darwin
    ];
  };

  passthru = oldAttrs.passthru // {
    home = "${jetbrains.jdk}/lib/openjdk";
  };
})
