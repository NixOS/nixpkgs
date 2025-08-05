{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytools,
  appdirs,
  six,
  cgen,
}:

buildPythonPackage rec {
  pname = "codepy";
  version = "2025.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "codepy";
    tag = "v${version}";
    hash = "sha256-PHIC3q9jQlRRoUoemVtyrl5hcZXMX28gRkI5Xpk9yBY=";
  };

  buildInputs = [
    pytools
    six
    cgen
  ];
  propagatedBuildInputs = [ appdirs ];

  pythonImportsCheck = [ "codepy" ];

  # Tests are broken
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/inducer/codepy";
    description = "Generate and execute native code at run time, from Python";
    license = licenses.mit;
    maintainers = with maintainers; [ atila ];
  };
}
