{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.7.6.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qzRDaBTi8YI481aI/YabJkGy0tjcoiuNJG9nAd/JVMg=";
  };

  propagatedBuildInputs = [
    six
  ];

  # darwin seems to hang
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m ppft.tests
    runHook postCheck
  '';

  pythonImportsCheck = [
    "ppft"
  ];

  meta = with lib; {
    description = "Distributed and parallel Python";
    homepage = "https://ppft.readthedocs.io/";
    changelog = "https://github.com/uqfoundation/ppft/releases/tag/ppft-${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
