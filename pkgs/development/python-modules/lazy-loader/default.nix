{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lazy-loader";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scientific-python";
    repo = "lazy_loader";
    tag = "v${version}";
    hash = "sha256-4Kid6yhm9C2liPoW+NlCsOiBZvv6iYt7hDunARc4PRY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lazy_loader" ];

  meta = with lib; {
    description = "Populate library namespace without incurring immediate import costs";
    homepage = "https://github.com/scientific-python/lazy_loader";
    changelog = "https://github.com/scientific-python/lazy_loader/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
