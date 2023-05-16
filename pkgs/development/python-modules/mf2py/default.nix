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
<<<<<<< HEAD
  version = "1.1.3";
=======
  version = "1.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "microformats";
    repo = "mf2py";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-Ya8DND1Dqbygbf1hjIGMlPwyc/MYIWIj+KnWB6Bqu1k=";
=======
    rev = version;
    hash = "sha256-9pAD/eCmc/l7LGmKixDhZy3hhj1jCmcyo9wbqgtz/wI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
