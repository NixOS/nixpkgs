{ stdenvNoCC, lib, fetchurl, cabextract }:

stdenvNoCC.mkDerivation rec {
  pname = "xow_dongle-firmware";
  version = "2017-07";

  dontConfigure = true;
  dontBuild = true;

  src = fetchurl {
    url = "http://download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/07/1cd6a87c-623f-4407-a52d-c31be49e925c_e19f60808bdcbfbd3c3df6be3e71ffc52e43261e.cab";
    sha256 = "013g1zngxffavqrk5jy934q3bdhsv6z05ilfixdn8dj0zy26lwv5";
  };

  nativeBuildInputs = [ cabextract ];

  sourceRoot = ".";

  unpackCmd = ''
    cabextract -F FW_ACC_00U.bin ${src}
  '';

  installPhase = ''
    install -Dm644 FW_ACC_00U.bin ${placeholder "out"}/lib/firmware/xow_dongle.bin
  '';

  meta = with lib; {
    description = "Xbox One wireless dongle firmware";
    homepage = "https://www.xbox.com/en-NZ/accessories/adapters/wireless-adapter-windows";
    license = licenses.unfree;
    maintainers = with lib.maintainers; [ rhysmdnz ];
    platforms = platforms.linux;
  };
}
