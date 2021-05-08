{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "rst2ansi";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vzy6gd60l79ff750scl0sz48r1laalkl6md6dwzah4dcadgn5qv";
  };

  propagatedBuildInputs = [ docutils ];

  # no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Snaipe/python-rst-to-ansi";
    license = licenses.mit;
    description = "A rst converter to ansi-decorated console output";
    maintainers = [ maintainers.uri-canva ];
  };
}
