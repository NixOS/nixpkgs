{ lib
, stdenv
, fetchFromGitHub
, jetbrains
, jdk
, git
, autoconf
, unzip
, rsync
, debugBuild ? false
, withJcef ? true

, libXdamage
, libXxf86vm
, libXrandr
, libXi
, libXcursor
, libXrender
, libX11
, libXext
, libxcb
, nss
, nspr
, libdrm
, mesa
, wayland
, udev
}:

assert debugBuild -> withJcef;

let
  arch = {
    "aarch64-linux" = "aarch64";
    "x86_64-linux" = "x64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  cpu = stdenv.hostPlatform.parsed.cpu.name;
in
jdk.overrideAttrs (oldAttrs: rec {
  pname = "jetbrains-jdk" + lib.optionalString withJcef "-jcef";
  javaVersion = "21.0.3";
  build = "509.11";
  # To get the new tag:
  # git clone https://github.com/jetbrains/jetbrainsruntime
  # cd jetbrainsruntime
  # git checkout jbr-release-${javaVersion}b${build}
  # git log --simplify-by-decoration --decorate=short --pretty=short | grep "jbr-" --color=never | cut -d "(" -f2 | cut -d ")" -f1 | awk '{print $2}' | sort -t "-" -k 2 -g | tail -n 1 | tr -d ","
  openjdkTag = "jbr-21.0.2+13";
  version = "${javaVersion}-b${build}";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "JetBrainsRuntime";
    rev = "jb${version}";
    hash = "sha256-zTstmrH4KteR40BVDRfxOrl8aUQ26acE+ywscBd8sw8=";
  };

  BOOT_JDK = jdk.home;
  # run `git log -1 --pretty=%ct` in jdk repo for new value on update
  SOURCE_DATE_EPOCH = 1723453663;

  patches = [ ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    ${lib.optionalString withJcef "cp -r ${jetbrains.jcef} jcef_linux_${arch}"}

    sed \
        -e "s/OPENJDK_TAG=.*/OPENJDK_TAG=${openjdkTag}/" \
        -e "s/SOURCE_DATE_EPOCH=.*//" \
        -e "s/export SOURCE_DATE_EPOCH//" \
        -i jb/project/tools/common/scripts/common.sh
    configureFlags=$(echo $configureFlags | sed 's/--host=[^ ]*//')
    sed -i "s|STATIC_CONF_ARGS|STATIC_CONF_ARGS \$configureFlags|" jb/project/tools/linux/scripts/mkimages_${arch}.sh
    sed \
        -e "s/create_image_bundle \"jb/#/" \
        -e "s/echo Creating /exit 0 #/" \
        -i jb/project/tools/linux/scripts/mkimages_${arch}.sh

    patchShebangs .
    ./jb/project/tools/linux/scripts/mkimages_${arch}.sh ${build} ${if debugBuild then "fd" else (if withJcef then "jcef" else "nomod")}

    runHook postBuild
  '';

  installPhase =
    let
      buildType = if debugBuild then "fastdebug" else "release";
      debugSuffix = if debugBuild then "-fastdebug" else "";
      jcefSuffix = if debugBuild || !withJcef then "" else "_jcef";
      jbrsdkDir = "jbrsdk${jcefSuffix}-${javaVersion}-linux-${arch}${debugSuffix}-b${build}";
    in
    ''
      runHook preInstall

      mv build/linux-${cpu}-server-${buildType}/images/jdk/man build/linux-${cpu}-server-${buildType}/images/${jbrsdkDir}
      rm -rf build/linux-${cpu}-server-${buildType}/images/jdk
      mv build/linux-${cpu}-server-${buildType}/images/${jbrsdkDir} build/linux-${cpu}-server-${buildType}/images/jdk
    '' + oldAttrs.installPhase + "runHook postInstall";

  postInstall = lib.optionalString withJcef ''
    chmod +x $out/lib/openjdk/lib/chrome-sandbox
  '';

  dontStrip = debugBuild;

  postFixup = ''
    # Build the set of output library directories to rpath against
    LIBDIRS="${lib.makeLibraryPath [
      libXdamage libXxf86vm libXrandr libXi libXcursor libXrender libX11 libXext libxcb
      nss nspr libdrm mesa wayland udev
    ]}"
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

  nativeBuildInputs = [ git autoconf unzip rsync ] ++ oldAttrs.nativeBuildInputs;

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
    maintainers = with maintainers; [ edwtjo ];

    broken = stdenv.isDarwin;
  };

  passthru = oldAttrs.passthru // {
    home = "${jetbrains.jdk}/lib/openjdk";
  };
})
