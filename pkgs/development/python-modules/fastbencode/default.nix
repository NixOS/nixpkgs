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
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X+DLfRc2iRr2HSreQM6UiUHUbpCLFvU4P1XxJ4SNoZc=";
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
    maintainers = with maintainers; [ ];
  };
}
