{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "bitstruct";
    tag = version;
    hash = "sha256-SJvXtBZHOPlL0WK8xNxyKQ/Sncf5fv3poxbRtiaMUlM=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "bitstruct" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python bit pack/unpack package";
    homepage = "https://github.com/eerimoq/bitstruct";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
}
