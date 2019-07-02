{ lib, buildPythonPackage, fetchPypi, isPy27
, click
, ipython
, pytest
, sh
, typing
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i25gh8wi87l4g0iflp81rlgmps4cdmp90hwypalp7gcbwfxfmzi";
  };

  propagatedBuildInputs = [ click ] ++ lib.optionals isPy27 [ typing ];

  checkInputs = [ ipython pytest sh ];

  # cli tests are impure
  checkPhase = ''
    pytest tests/ -k 'not cli'
  '';

  meta = with lib; {
    description = "Add .env support to your django/flask apps in development and deployments";
    homepage = https://github.com/theskumar/python-dotenv;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ earvstedt ];
  };
}
