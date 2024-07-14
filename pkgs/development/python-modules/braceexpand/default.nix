{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "braceexpand";
  version = "0.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-5uU5vSDq6lNUdHL/lPT7XD07+dCok4jEtWZjq6dl9wU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braceexpand" ];

  meta = with lib; {
    description = "Bash-style brace expansion for Python";
    homepage = "https://github.com/trendels/braceexpand";
    changelog = "https://github.com/trendels/braceexpand/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
