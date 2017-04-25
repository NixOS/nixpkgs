{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "iso-639";
  version = "0.4.5";

  src = fetchurl {
    url = "mirror://pypi/i/${pname}/${name}.tar.gz";
    sha256 = "dc9cd4b880b898d774c47fe9775167404af8a85dd889d58f9008035109acce49";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/noumar/iso639;
    description = "ISO 639 library for Python";
    license = licenses.agpl3;
    maintainers = with maintainers; [ zraexy ];
  };
}
