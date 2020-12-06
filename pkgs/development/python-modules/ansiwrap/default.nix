{ lib
, buildPythonPackage
, fetchPypi
, tox
, pytest
, ansicolors
, coverage
, pytestcov
, textwrap3
}:

buildPythonPackage rec {
  pname = "ansiwrap";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "ca0c740734cde59bf919f8ff2c386f74f9a369818cdc60efe94893d01ea8d9b7";
  };

  checkInputs = [
    tox
    pytest
    ansicolors
    coverage
    pytestcov
  ];

  propagatedBuildInputs = [
    textwrap3
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Textwrap, but savvy to ANSI colors and styles";
    homepage = "https://github.com/jonathaneunice/ansiwrap";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
