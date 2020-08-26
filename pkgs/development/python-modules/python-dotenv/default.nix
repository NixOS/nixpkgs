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
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gf3r4xvqk9ai1k3ka8c4dlblqhs7286zbd1b20adn953fdcj44c";
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
