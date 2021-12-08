{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, jinja2
, selenium
, six
, setuptools
}:

buildPythonPackage rec {
  pname = "branca";
  version = "0.4.2";

  src = fetchFromGitHub {
     owner = "python-visualization";
     repo = "branca";
     rev = "v0.4.2";
     sha256 = "016gvpmw5hggs1q77f9k014k7mb03yxk1aashyd24cw908zjlqgz";
  };

  checkInputs = [ pytest selenium ];
  propagatedBuildInputs = [ jinja2 six setuptools ];

  # Seems to require a browser
  doCheck = false;

  meta = {
    description = "Generate complex HTML+JS pages with Python";
    homepage = "https://github.com/python-visualization/branca";
    license = with lib.licenses; [ mit ];
  };
}
