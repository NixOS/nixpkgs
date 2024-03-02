{ lib
, buildPythonPackage
, fetchFromGitHub
, pytools
, appdirs
, six
, cgen
}:

buildPythonPackage rec {
  pname = "codepy";
  version = "2019.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "inducer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-viMfB/nDrvDA/IGRZEX+yXylxbbmqbh/fgdYXBzK0zM=";
  };

  buildInputs = [ pytools six cgen ];
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
