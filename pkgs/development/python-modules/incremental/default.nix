{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "incremental";
  version = "17.5.0";

  src = fetchurl {
    url = "mirror://pypi/i/${pname}/${name}.tar.gz";
    sha256 = "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3";
  };

  meta = with stdenv.lib; {
    homepage = http://github.com/twisted/treq;
    description = "Incremental is a small library that versions your Python projects";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
