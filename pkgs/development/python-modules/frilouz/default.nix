{
  lib,
  astunparse,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "frilouz";
  version = "0.0.2";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "QuantStack";
    repo = "frilouz";
    rev = version;
    hash = "sha256-PDZWgnbo9qtCn1IvAKH/HrgdgFehBGJ4TBmE9Un8WHA=";
  };

  nativeCheckInputs = [ astunparse ];

  preCheck = "cd test";

  checkPhase = ''
    runHook preCheck
    python -m unittest
    runHook postCheck
  '';

  pythonImportsCheck = [ "frilouz" ];

  meta = {
    homepage = "https://github.com/QuantStack/frilouz";
    description = "Python AST parser adapter with partial error recovery";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
