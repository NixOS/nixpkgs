{ lib
, buildPythonPackage
, colorlog
, fetchPypi
, pythonOlder
, pyserial
}:

buildPythonPackage rec {
  pname = "pypca";
  version = "0.0.13";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y0p2rm22x21mykipiv42fjc79b0969qsbhk3cqkrdnqwh5psbdl";
  };

  propagatedBuildInputs = [
    colorlog
    pyserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypca" ];

  meta = with lib; {
    description = "Python library for interacting with the PCA 301 smart plugs";
    homepage = "https://github.com/majuss/pypca";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
