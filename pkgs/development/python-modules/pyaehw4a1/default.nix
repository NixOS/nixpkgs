{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyaehw4a1";
  version = "0.3.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bannhead";
    repo = "pyaehw4a1";
    rev = "v${version}";
    hash = "sha256-W+rTKprj0nwIAPetzl+N10lu6Zuze8Hrx5x+6OM8Oj8=";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyaehw4a1" ];

  meta = {
    description = "Python interface for Hisense AEH-W4A1 module";
    homepage = "https://github.com/bannhead/pyaehw4a1";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
