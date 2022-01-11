{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, isPy3k
, mock
, nose
}:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.8.1";
  disable = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Qbv/N9YYZDD3f5ANd35btqJJKKHEb7HeaS+LUriDO1w=";
  };

  checkInputs = [
    nose
    mock
    glibcLocales
  ];

  checkPhase = ''
    runHook preCheck
    LC_ALL="en_US.UTF-8" nosetests -v
    runHook postCheck
  '';

  pythonImportsCheck = [ "parameterized" ];

  meta = with lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = "https://github.com/wolever/parameterized";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
