{ lib
, buildPythonPackage
, fetchPypi
, argcomplete
, colorama
, jmespath
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
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4eaa50a1c5e79d1c5c8e5e1705b661721b0b83a089695e59e229cc26c64963b9";
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
    homepage = "https://github.com/microsoft/knack";
    description = "A Command-Line Interface framework";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
