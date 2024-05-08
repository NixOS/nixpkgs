{ lib
, stdenv
, fetchurl
, binutils
}:

stdenv.mkDerivation rec {
  pname = "ultraleap-udev-rules";
  version = "5.17.1";

  src = fetchurl {
    url = "https://repo.ultraleap.com/apt/pool/main/u/ultraleap-hand-tracking-service/ultraleap-hand-tracking-service_5.17.1.0-a9f25232-1.0_amd64.deb";
    hash = "sha256-nZFi5NEzrPf0MMDoEnzDPILaLLtwDx7gTt7/X6uY4OQ=";
  };
  
  buildInputs = [
    binutils
  ];

  buildCommand = ''
    # Unpack
    ar vx $src
    tar xvf data.tar.gz
    mkdir -p $out/lib/udev
    cp -r lib/udev/rules.d $out/lib/udev
  '';

  meta = with lib; {
    description = "Ultraleap Udev Rules";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pandapip1 ];
  };
}
