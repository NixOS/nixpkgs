{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "libctb";
  version = "0.16";
  src = fetchurl {
    url = "https://iftools.com/download/files/legacy/${pname}-${version}.tar.gz";
    sha256 = "027wh89d0qyly3d9m6rg4x7x1gqz3y3cnxlgk0k8xgygcrm05c0w";
  };
  patches = [
    ./include-kbhit.patch
  ];
  sourceRoot = "${pname}-${version}/build";
  makeFlags = [
    "prefix=$(out)"
  ];
  meta = with lib; {
    description = "Communications toolbox";
    homepage = "https://iftools.com";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.misuzu ];
  };
}
