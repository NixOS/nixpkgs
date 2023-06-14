{ lib
, stdenv
, fetchFromGitHub
, jetbrains
, openjdk17
, openjdk17-bootstrap
, git
, autoconf
, unzip
, rsync
, debugBuild ? false

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

openjdk17.overrideAttrs (oldAttrs: rec {
  pname = "jetbrains-jdk-jcef";
  javaVersion = "17.0.7";
  build = "829.16";
  # To get the new tag:
  # git clone https://github.com/jetbrains/jetbrainsruntime
  # cd jetbrainsruntime
  # git reset --hard [revision]
  # git log --simplify-by-decoration --decorate=short --pretty=short | grep "jdk-" | cut -d "(" -f2 | cut -d ")" -f1 | awk '{print $2}' | sort -t "-" -k 2 -g | tail -n 1
  openjdkTag = "jdk-18+0";
  version = "${javaVersion}-b${build}";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "JetBrainsRuntime";
    rev = "jb${version}";
    hash = "sha256-b3wW52knkYUeG8h4naTQLGUedhAMiPnUsn3zFAiJCwM=";
  };

  BOOT_JDK = openjdk17-bootstrap.home;
  SOURCE_DATE_EPOCH = 1666098567;

  patches = [];

  # Configure is done in build phase
  configurePhase = "true";

  buildPhase = ''
    runHook preBuild

    mkdir -p jcef_linux_x64/jmods
    cp ${jetbrains.jcef}/* jcef_linux_x64/jmods

    sed \
        -e "s/OPENJDK_TAG=.*/OPENJDK_TAG=${openjdkTag}/" \
        -e "s/SOURCE_DATE_EPOCH=.*//" \
        -e "s/export SOURCE_DATE_EPOCH//" \
        -i jb/project/tools/common/scripts/common.sh
    sed -i "s/STATIC_CONF_ARGS/STATIC_CONF_ARGS \$configureFlags/" jb/project/tools/linux/scripts/mkimages_x64.sh
    sed \
        -e "s/create_image_bundle \"jb/#/" \
        -e "s/echo Creating /exit 0 #/" \
        -i jb/project/tools/linux/scripts/mkimages_x64.sh

    patchShebangs .
    ./jb/project/tools/linux/scripts/mkimages_x64.sh ${build} ${if debugBuild then "fd" else "jcef"}

    runHook postBuild
  '';

  installPhase = let
    buildType = if debugBuild then "fastdebug" else "release";
    debugSuffix = lib.optionalString debugBuild "-fastdebug";
    jcefSuffix = lib.optionalString (!debugBuild) "_jcef";
  in ''
    runHook preInstall

    mv build/linux-x86_64-server-${buildType}/images/jdk/man build/linux-x86_64-server-${buildType}/images/jbrsdk${jcefSuffix}-${javaVersion}-linux-x64${debugSuffix}-b${build}
    rm -rf build/linux-x86_64-server-${buildType}/images/jdk
    mv build/linux-x86_64-server-${buildType}/images/jbrsdk${jcefSuffix}-${javaVersion}-linux-x64${debugSuffix}-b${build} build/linux-x86_64-server-${buildType}/images/jdk
  '' + oldAttrs.installPhase + "runHook postInstall";

  postInstall = ''
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
    description = "An OpenJDK fork to better support Jetbrains's products.";
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
    inherit (openjdk17.meta) license platforms mainProgram;
    maintainers = with maintainers; [ edwtjo ];

    broken = stdenv.isDarwin;
  };

  passthru = oldAttrs.passthru // {
    home = "${jetbrains.jdk}/lib/openjdk";
  };
})
