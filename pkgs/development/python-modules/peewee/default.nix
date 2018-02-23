{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "peewee";
  version ="2.8.8";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1l99j1pa6ijxd42xdwgl72w8apa34c03ixw2dcmfdkcfrz4s2wj5";
  };

  # The peewee distribution on pypi doesn't include tests.
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/coleifer/peewee;
    license = licenses.mit;
    description = "A small, expressive orm";
  };
}

