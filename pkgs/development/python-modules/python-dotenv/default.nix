{ lib, buildPythonPackage, fetchPypi, isPy27
, click
, ipython
, pytest
, sh
, typing
, mock
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "587825ed60b1711daea4832cf37524dfd404325b7db5e25ebe88c495c9f807a0";
  };

  propagatedBuildInputs = [ click ] ++ lib.optionals isPy27 [ typing ];

  checkInputs = [ ipython mock pytest sh ];

  # cli tests are impure
  checkPhase = ''
    pytest tests/ -k 'not cli'
  '';

  meta = with lib; {
    description = "Add .env support to your django/flask apps in development and deployments";
    homepage = "https://github.com/theskumar/python-dotenv";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ earvstedt ];
  };
}
