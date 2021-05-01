{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "rst2ansi";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "python-rst2ansi";
    rev = "v${version}";
    sha256 = "0h4s0g9kj6wgp8g2vsqajy3vish463za7q91k6674cdkfh9hsq46";
  };

  propagatedBuildInputs = [
    docutils
  ];

  # Project only has templates to tests but no tests
  doCheck = false;
  pythonImportsCheck = [ "rst2ansi" ];

  meta = with lib; {
    description = "Python module for rendering RST";
    homepage = "https://github.com/Snaipe/python-rst2ansi/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
