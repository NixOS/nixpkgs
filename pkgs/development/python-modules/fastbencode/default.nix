{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fastbencode";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o0wyxQSw7J3hpJk0btJJMjWetGI0sotwl1pQ/fqhSrU=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  pythonImportsCheck = [ "fastbencode" ];

  checkPhase = ''
    ${python.interpreter} -m unittest fastbencode.tests.test_suite
  '';

  meta = with lib; {
    description = "Fast implementation of bencode";
    homepage = "https://github.com/breezy-team/fastbencode";
    changelog = "https://github.com/breezy-team/fastbencode/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
