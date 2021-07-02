{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aenum
}:

buildPythonPackage rec {
  pname = "bytecode";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = version;
    sha256 = "sha256-CEfDoJ+JlnxLLVnSxv7bEN891tmwG9zAvtT8GNvp8JU=";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = lib.optionals (pythonOlder "3.6") [ aenum ];

  meta = with lib; {
    homepage = "https://github.com/vstinner/bytecode";
    description = "Python module to generate and modify bytecode";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
