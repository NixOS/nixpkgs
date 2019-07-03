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
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kxxj9m2mvva9rz11m6pgdg0mi712d28faj4633rl23qa53sh7i8";
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

  # tries to make a '/homeless-shelter' dir
  checkPhase = ''
    pytest -k 'not test_cli_exapp1'
  '';

  meta = with lib; {
    homepage = https://github.com/microsoft/knack;
    description = "A Command-Line Interface framework";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
