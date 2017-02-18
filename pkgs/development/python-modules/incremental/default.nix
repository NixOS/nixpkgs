{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "incremental";
  version = "16.10.1";

  src = fetchurl {
    url = "mirror://pypi/i/${pname}/${name}.tar.gz";
    sha256 = "0hh382gsj5lfl3fsabblk2djngl4n5yy90xakinasyn41rr6pb8l";
  };

  meta = with stdenv.lib; {
    homepage = http://github.com/twisted/treq;
    description = "Incremental is a small library that versions your Python projects";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
