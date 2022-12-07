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
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xXKBKCl+bSaXkQhc+Wwv/fzvWM+DxjSly5LrA7KSmDg=";
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
    changelog = "https://github.com/microsoft/knack/blob/v${version}/HISTORY.rst";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
