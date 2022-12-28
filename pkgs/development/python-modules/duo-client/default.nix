{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, mock
, nose2
, pytz
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "duo-client";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "duosecurity";
    repo = "duo_client_python";
    rev = version;
    sha256 = "sha256-9ADFtCrSJ4Y2QQY5YC/BMvoVZs2vaYHkhIM/rBlZm4I=";
  };

  postPatch = ''
    substituteInPlace requirements-dev.txt \
      --replace "dlint" "" \
      --replace "flake8" ""
  '';

  propagatedBuildInputs = [
    setuptools
    six
  ];

  checkInputs = [
    freezegun
    mock
    nose2
    pytz
  ];

  pythonImportsCheck = [ "duo_client" ];

  meta = with lib; {
    description = "Python library for interacting with the Duo Auth, Admin, and Accounts APIs";
    homepage = "https://github.com/duosecurity/duo_client_python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
