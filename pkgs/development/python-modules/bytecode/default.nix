{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aenum
}:

buildPythonPackage rec {
  pname = "bytecode";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = version;
    sha256 = "097k83zr0z71pha7bafzhs4ink174wk9ls2883bic274rihsnc5r";
  };

  disabled = pythonOlder "3.5";

  requiredPythonModules = lib.optionals (pythonOlder "3.6") [ aenum ];

  meta = with lib; {
    homepage = "https://github.com/vstinner/bytecode";
    description = "Python module to generate and modify bytecode";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
