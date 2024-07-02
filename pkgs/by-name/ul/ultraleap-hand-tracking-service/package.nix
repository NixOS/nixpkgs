{ autoPatchelfHook
, dpkg
, fetchurl
, lib
, stdenv
, udev
}:
stdenv.mkDerivation {
  pname = "ultraleap-hand-tracking-service";
  version = "5.17.1.0";

  src = fetchurl {
    url = "https://repo.ultraleap.com/apt/pool/main/u/ultraleap-hand-tracking-service/ultraleap-hand-tracking-service_5.17.1.0-a9f25232-1.0_amd64.deb";
    hash = "sha256-nZFi5NEzrPf0MMDoEnzDPILaLLtwDx7gTt7/X6uY4OQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];
  buildInputs = [ stdenv.cc.cc.lib udev ];

  patches = [
    ./fix-cmake-paths.patch
  ];

  dontBuild = true;

  outputs = [ "out" "dev" ];

  installPhase = ''
    runHook preInstall

    install -d $out/bin
    cp -Tr usr/bin $out/bin

    install -d $out/lib
    cp -Tr lib $out/lib
    cp -Tr usr/lib/ultraleap-hand-tracking-service $out/lib
    rm -r $out/lib/cmake

    install -d $out/share
    cp -Tr usr/share $out/share

    install -d $dev/include
    cp -Tr usr/include $dev/include

    install -d $dev/lib/cmake
    cp -Tr usr/lib/x86_64-linux-gnu/cmake $dev/lib/cmake
    cp -Tr usr/lib/ultraleap-hand-tracking-service/cmake $dev/lib/cmake

    substituteInPlace $out/lib/systemd/system/ultraleap-hand-tracking-service.service \
      --replace-fail "/usr/bin/leapd" "$out/bin/leapd"

    substituteInPlace $dev/lib/cmake/LeapCTargets.cmake \
      --subst-var "dev"
    substituteInPlace $dev/lib/cmake/LeapCTargets-release.cmake \
      --subst-var "out"
    substituteInPlace $dev/lib/cmake/LeapSDK/leapsdk-config.cmake \
      --subst-var "dev"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Ultraleap Hand Tracking service";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Scrumplex pandapip1 ];
  };
}
