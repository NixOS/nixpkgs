{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, argcomplete
, colorama
, jmespath
, knack
, pygments
, pyyaml
, six
, tabulate
, mock
, vcrpy
, pytest
}:

buildPythonPackage rec {
  pname = "knack";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08g15kwfppdr7vhbsg6qclpqbf11d9k3hwgrmvhh5fa1jrk95b5i";
  };

  propagatedBuildInputs = [
    argcomplete
    colorama
    jmespath
    pygments
    pyyaml
    six
    tabulate
  ];

  checkInputs = [
    mock
    vcrpy
    pytest
  ];

  checkPhase = ''
    HOME=$TMPDIR pytest .
  '';

  meta = with lib; {
    homepage = https://github.com/microsoft/knack;
    description = "A Command-Line Interface framework";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
