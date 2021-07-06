{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, six
, enum34
, pathlib
, ordereddict
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyScss";
  version = "1.3.7";

  src = fetchFromGitHub {
    repo = "pyScss";
    owner = "Kronuz";
    rev = version;
    sha256 = "0701hziiiw67blafgpmjhzspmrss8mfvif7fw0rs8fikddwwc9g6";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ six ]
    ++ (lib.optionals (pythonOlder "3.4") [ enum34 pathlib ])
    ++ (lib.optionals (pythonOlder "2.7") [ ordereddict ]);

  # Test suite is broken.
  # See https://github.com/Kronuz/pyScss/issues/415
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "A Scss compiler for Python";
    homepage = "https://pyscss.readthedocs.org/en/latest/";
    license = licenses.mit;
  };

}
