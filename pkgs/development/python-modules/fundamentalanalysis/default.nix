{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, setuptools
, pytestCheckHook, poetry-core }:

buildPythonPackage rec {
  # note: this package is replaced by financetoolkit
  # this exists because openbb-terminal requires both
  pname = "fundamentalanalysis";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-azvg5FasVQuVfq2FzxXkE8DJ4GOHfGYx28qd0JxLjNM=";
  };

  prePatch = ''
    # allow later version of setuptools
    substituteInPlace pyproject.toml \
      --replace 'setuptools = "<65.5.0"' 'setuptools = "*"' \
      --replace 'requires = ["setuptools<65.5.0", "poetry-core>=1.0.0"]' 'requires = ["poetry-core>=1.0.0"]'
    # remove deprecation warning on import
    echo "" > fundamentalanalysis/__init__.py
  '';

  nativeBuildInputs = [ setuptools poetry-core ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fundamentalanalysis" ];

  meta = with lib; {
    changelog =
      "https://github.com/JerBouma/FinanceToolkit/releases/tag/${version}";
    description = "Transparent and Efficient Financial Analysis";
    homepage = "https://github.com/JerBouma/FinanceToolkit";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
