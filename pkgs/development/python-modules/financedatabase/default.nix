{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, setuptools
, pytestCheckHook, poetry-core, pandas, financetoolkit }:

buildPythonPackage rec {
  pname = "financedatabase";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oYDfwmxYWqn9SdKJg7qvTa7GrGYZ/VMzYrhNQJCXLOM=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools = "<65.5.0"' 'setuptools = "*"' \
      --replace 'requires = ["setuptools<65.5.0", "poetry-core>=1.0.0"]' 'requires = ["poetry-core>=1.0.0"]'
  '';

  nativeBuildInputs = [ setuptools poetry-core ];

  propagatedBuildInputs = [ pandas financetoolkit ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "financedatabase" ];

  meta = with lib; {
    changelog =
      "https://github.com/JerBouma/FinanceDatabase/releases/tag/${version}";
    description =
      "This is a database of 300.000+ symbols containing Equities, ETFs, Funds, Indices, Currencies, Cryptocurrencies and Money Markets.";
    homepage = "https://github.com/JerBouma/FinanceDatabase";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
