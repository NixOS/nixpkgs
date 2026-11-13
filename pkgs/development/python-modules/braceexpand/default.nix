{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "braceexpand";
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-5uU5vSDq6lNUdHL/lPT7XD07+dCok4jEtWZjq6dl9wU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braceexpand" ];

  meta = {
    description = "Bash-style brace expansion for Python";
    homepage = "https://github.com/trendels/braceexpand";
    changelog = "https://github.com/trendels/braceexpand/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      newam
      pbsds
    ];
  };
}
