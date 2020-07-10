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
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcef6040164ebe7d69629e4e089b398c9b980791446496301befcf8381dba0fc";
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
