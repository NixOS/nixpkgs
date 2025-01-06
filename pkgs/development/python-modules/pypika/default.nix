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

  meta = {
    description = "Python SQL query builder";
    homepage = "https://github.com/kayak/pypika";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ blaggacao ];
  };
}
