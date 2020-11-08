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
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfc6aef6760ea9a9620577e01540617678d78cab3111a0f03e8b9f987d0f08ca";
  };

  requiredPythonModules = [
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
