{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "PyXB";
  version = "1.2.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d17pyixbfvjyi2lb0cfp0ch8wwdf44mmg3r5pwqhyyqs66z601a";
  };

  pythonImportsCheck = [
    "pyxb"
  ];

  # tests don't complete
  # https://github.com/pabigot/pyxb/issues/130
  doCheck = false;

  meta = with lib; {
    description = "Python XML Schema Bindings";
    homepage = "https://github.com/pabigot/pyxb";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
