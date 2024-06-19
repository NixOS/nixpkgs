{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  parameterized,
  unittestCheckHook,
}:
buildPythonPackage rec {
  pname = "pypika";
  version = "0.48.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kayak";
    repo = "pypika";
    rev = "v${version}";
    hash = "sha256-9HKT1xRu23F5ptiKhIgIR8srLIcpDzpowBNuYOhqMU0=";
  };

  pythonImportsCheck = [ "pypika" ];

  nativeCheckInputs = [
    parameterized
    unittestCheckHook
  ];

  meta = with lib; {
    description = "A python SQL query builder";
    homepage = "https://github.com/kayak/pypika";
    license = licenses.asl20;
    maintainers = with maintainers; [ blaggacao ];
  };
}
