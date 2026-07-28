{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "miniflux";
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "python-client";
    tag = version;
    hash = "sha256-xzQozsf6FURdf5HI6U8/26jbFmVYWDqXFt77iZ7pqP8=";
  };
  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "miniflux" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Miniflux Python API Client";
    homepage = "https://github.com/miniflux/python-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wariuccio ];
  };
}
