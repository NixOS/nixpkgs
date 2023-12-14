{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, requests, setuptools
, pytestCheckHook, poetry-core, pandas, scipy, scikit-learn }:

buildPythonPackage rec {
  pname = "financetoolkit";
  version = "1.6.6";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1vS5OfdLwWkEfJNDjT6gtvJY+mxrkvB4/UeOHaDd1Cc=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools = "<65.5.0"' 'setuptools = "*"' \
      --replace 'requires = ["setuptools<65.5.0", "poetry-core>=1.0.0"]' 'requires = ["poetry-core>=1.0.0"]'
  '';

  nativeBuildInputs = [ setuptools poetry-core ];

  propagatedBuildInputs = [ pandas requests scipy scikit-learn ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "financetoolkit" ];

  meta = with lib; {
    changelog =
      "https://github.com/JerBouma/FinanceToolkit/releases/tag/${version}";
    description = "Transparent and Efficient Financial Analysis";
    homepage = "https://github.com/JerBouma/FinanceToolkit";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
