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
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b9909bc96b0edc6b01586e1eed05e71174ef4e04c71da5786370cebea53ad74";
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
