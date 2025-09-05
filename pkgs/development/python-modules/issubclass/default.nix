{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "issubclass";
  version = "0.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zmievsa";
    repo = "issubclass";
    tag = version;
    hash = "sha256-a4EUbQY5duicnxuwtpBQ/7UBmtmeU+ZaySEnT4lmgLs=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "issubclass" ];

  meta = {
    description = "issubclass() builtin that doesn't raise TypeError when arguments are not classes";
    homepage = "https://pypi.org/project/issubclass";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
}
