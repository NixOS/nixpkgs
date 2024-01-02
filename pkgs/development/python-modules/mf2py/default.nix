{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, html5lib
, requests
, lxml
, mock
, nose
}:

buildPythonPackage rec {
  pname = "mf2py";
  version = "1.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "microformats";
    repo = "mf2py";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ya8DND1Dqbygbf1hjIGMlPwyc/MYIWIj+KnWB6Bqu1k=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    html5lib
    requests
  ];

  nativeCheckInputs = [
    lxml
    mock
    nose
  ];

  pythonImportsCheck = [ "mf2py" ];

  meta = with lib; {
    description = "Microformats2 parser written in Python";
    homepage = "https://microformats.org/wiki/mf2py";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
