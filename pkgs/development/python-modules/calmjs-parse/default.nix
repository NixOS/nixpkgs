{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, ply
, python
}:

buildPythonPackage rec {
  pname = "calmjs-parse";
  version = "1.3.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "calmjs";
    repo = "calmjs.parse";
    rev = version;
    hash = "sha256-QhHNp9g88RhGHqRRjg4nk7aXjAgGCOauOagWJoJ3fqc=";
  };

  propagatedBuildInputs = [
    setuptools
    ply
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m unittest calmjs.parse.tests.make_suite

    runHook postCheck
  '';

  pythonImportsCheck = [
    "calmjs.parse"
    "calmjs.parse.asttypes"
    "calmjs.parse.parsers"
    "calmjs.parse.rules"
    "calmjs.parse.sourcemap"
    "calmjs.parse.unparsers.es5"
    "calmjs.parse.walkers"
  ];

  meta = with lib; {
    description = "Various parsers for ECMA standards";
    homepage = "https://github.com/calmjs/calmjs.parse";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
