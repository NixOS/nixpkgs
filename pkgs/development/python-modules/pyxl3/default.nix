{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  isPy27,
}:

buildPythonPackage rec {
  pname = "pyxl3";
  version = "1.4";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "gvanrossum";
    repo = pname;
    rev = "e6588c12caee49c43faf6aa260f04d7e971f6aa8";
    hash = "sha256-8nKQgwLXPVgPxNRF4CryKJb7+llDsZHis5VctxqpIRo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python 3 port of pyxl for writing structured and reusable inline HTML";
    homepage = "https://github.com/gvanrossum/pyxl3";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
