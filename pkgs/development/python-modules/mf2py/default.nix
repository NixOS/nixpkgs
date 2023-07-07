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
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "microformats";
    repo = "mf2py";
    rev = version;
    hash = "sha256-9pAD/eCmc/l7LGmKixDhZy3hhj1jCmcyo9wbqgtz/wI=";
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
