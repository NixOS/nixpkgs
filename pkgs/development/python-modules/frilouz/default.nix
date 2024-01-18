{ lib
, astunparse
, buildPythonPackage
, fetchFromGitHub
, isPy3k
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
    sha256 = "0w2qzi4zb10r9iw64151ay01vf0yzyhh0bsjkx1apxp8fs15cdiw";
  };

  nativeCheckInputs = [ astunparse ];

  preCheck = "cd test";

  checkPhase = ''
    runHook preCheck
    python -m unittest
    runHook postCheck
  '';

  pythonImportsCheck = [ "frilouz" ];

  meta = with lib; {
    homepage = "https://github.com/QuantStack/frilouz";
    description = "Python AST parser adapter with partial error recovery";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
  };
}
