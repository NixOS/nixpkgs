{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  coverage,
  six,
}:

buildPythonPackage rec {
  pname = "doubles";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uber";
    repo = "doubles";
    tag = "v${version}";
    hash = "sha256-7yygZ00H2eIGuI/E0dh0j30hicJKBhCqyagY6XAJTCA=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  # Tests are broken with pytest 8 and recent Python versions
  doCheck = false;

  pythonImportsCheck = [ "doubles" ];

  meta = with lib; {
    description = "Test doubles for Python";
    homepage = "https://github.com/uber/doubles";
    license = licenses.mit;
    maintainers = with maintainers; [ b-rodrigues ];
  };
}
