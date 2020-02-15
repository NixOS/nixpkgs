{ lib, buildPythonPackage, fetchPypi, isPy27
, click
, ipython
, pytest
, sh
, typing
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p6xk0f1yj1s4n8wjs9m8xqilc5bcwvfzsy9nv5lrmkhr78bym7j";
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
