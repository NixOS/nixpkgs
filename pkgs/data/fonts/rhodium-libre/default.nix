{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "RhodiumLibre";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "DunwichType";
    repo = pname;
    rev = version;
    sha256 = "1ihj2vx6yqqggah53dxh3alj5p7q6hil90jmxw33w0n4v18jy930";
  };

  meta = with lib; {
    description = "F/OSS/Libre font for Latin and Devanagari";
    homepage = "https://github.com/DunwichType/RhodiumLibre";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
