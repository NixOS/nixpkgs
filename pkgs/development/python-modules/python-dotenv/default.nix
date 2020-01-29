{ lib, buildPythonPackage, fetchPypi, isPy27
, click
, ipython
, pytest
, sh
, typing
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16s2x5ghrhz9ljm6h3y0pbwh97558vbs7l0yiicag4s0xyn0nzq0";
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
