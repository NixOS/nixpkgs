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
  version = "0.3.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1k3D2YP9Zc0tTVKiyt5B7yJVH0Pi1iqXydu1bFn0fgc=";
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
