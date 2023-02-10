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
  version = "1.7.6.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+TPwQE8+gIvIYHRayzt5zU/jHqGaIIiaZF+QBBW+YPE=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
