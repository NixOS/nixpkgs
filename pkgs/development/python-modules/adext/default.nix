{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, alarmdecoder
}:

buildPythonPackage rec {
  pname = "adext";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yz1rpfvhbf7kfjck5vadbj9rd3bkx5248whaa3impdrjh7vs03x";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    alarmdecoder
  ];

  # Tests are not published yet
  doCheck = false;
  pythonImportsCheck = [ "adext" ];

  meta = with lib; {
    description = "Python extension for AlarmDecoder";
    homepage = "https://github.com/ajschmidt8/adext";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
