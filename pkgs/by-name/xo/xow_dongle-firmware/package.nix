{
  stdenvNoCC,
  lib,
  fetchurl,
  cabextract,
}:
stdenvNoCC.mkDerivation rec {
  pname = "xow_dongle-firmware";
  version = "0-unstable-2025-04-22";

  srcs = [
    (fetchurl {
      name = "xow_dongle.cab";
      url = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/07/1cd6a87c-623f-4407-a52d-c31be49e925c_e19f60808bdcbfbd3c3df6be3e71ffc52e43261e.cab";
      hash = "sha256-ZXNqhP9ANmRbj47GAr7ZGrY1MBnJyzIz3sq5/uwPbwQ=";
    })
    (fetchurl {
      name = "xow_dongle_045e_02e6.cab";
      url = "https://catalog.s.download.windowsupdate.com/d/msdownload/update/driver/drvs/2015/12/20810869_8ce2975a7fbaa06bcfb0d8762a6275a1cf7c1dd3.cab";
      hash = "sha256-5jiKJ6dXVpIN5zryRo461V16/vWavDoLUICU4JHRnwg=";
    })
  ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ cabextract ];

  unpackPhase = ''
    sources=($srcs)

    cabextract -F FW_ACC_00U.bin ''${sources[0]}
    mv FW_ACC_00U.bin xow_dongle.bin

    cabextract -F FW_ACC_00U.bin ''${sources[1]}
    mv FW_ACC_00U.bin xow_dongle_045e_02e6.bin
  '';

  installPhase = ''
    install -Dm644 xow_dongle.bin $out/lib/firmware/xow_dongle.bin
    install -Dm644 xow_dongle_045e_02e6.bin $out/lib/firmware/xow_dongle_045e_02e6.bin
  '';

  meta = with lib; {
    description = "Xbox One wireless dongle firmware";
    homepage = "https://www.xbox.com/en-NZ/accessories/adapters/wireless-adapter-windows";
    license = licenses.unfree;
    maintainers = with maintainers; [
      rhysmdnz
      fazzi
    ];
    platforms = platforms.linux;
  };
}
