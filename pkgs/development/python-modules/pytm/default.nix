{ buildPythonPackage
, fetchFromGitHub
, lib
, pythonOlder
, pydal
, graphviz
, pandoc
, plantuml
}:

buildPythonPackage rec {
  pname = "pytm";
  version = "1.3.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "izar";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-R/MDz6lCvUxtn6IJ8STHlWzkSjnUJziO+oPnaYhrr7U=";
  };

  propagatedBuildInputs = [ pydal graphviz pandoc plantuml ];

  pythonImportsCheck = [ "pytm" ];

  meta = with lib; {
    description = "A Pythonic framework for threat modeling";
    homepage = "https://owasp.org/www-project-pytm/";
    license = with licenses; [ capec mit ];
    maintainers = with maintainers; [ wamserma ];
  };
}
