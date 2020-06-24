{ lib, mkFont, fetchurl, unzip }:

mkFont rec {
  pname = "meslo-lg";
  version = "1.2.1";

  srcs = [
    (fetchurl {
      url="https://github.com/andreberg/Meslo-Font/blob/master/dist/v${version}/Meslo%20LG%20v${version}.zip?raw=true";
      name="${pname}-${version}.zip";
      sha256="1l08mxlzaz3i5bamnfr49s2k4k23vdm64b8nz2ha33ysimkbgg6h";
    })

    (fetchurl {
      url="https://github.com/andreberg/Meslo-Font/blob/master/dist/v${version}/Meslo%20LG%20DZ%20v${version}.zip?raw=true";
      name="${pname}-${version}-dz.zip";
      sha256="0lnbkrvcpgz9chnvix79j6fiz36wj6n46brb7b1746182rl1l875";
    })
  ];

  nativeBuildInputs = [ unzip ];

  meta = with lib; {
    description = "A customized version of Apple’s Menlo-Regular font";
    homepage = "https://github.com/andreberg/Meslo-Font/";
    license = licenses.asl20;
    maintainers = with maintainers; [ balajisivaraman ];
    platforms = platforms.all;
  };
}
