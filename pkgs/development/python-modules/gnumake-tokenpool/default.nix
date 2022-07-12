{ lib
, fetchFromGitHub
, buildPythonPackage
}:

buildPythonPackage {
  pname = "gnumake-tokenpool";
  version = "unstable-2022-07-05";

  src = fetchFromGitHub {
    owner = "milahu";
    repo = "gnumake-tokenpool";
    rev = "54435c300e3b660cc75ffd8d63e518df322e6891";
    sha256 = "uHo5fMY7jsjX56gFod3X/seGVt+p8+lBfodGa/oaRsE=";
  };

  pythonImportsCheck = [
    "gnumake_tokenpool"
  ];

  meta = with lib; {
    description = "jobclient and jobserver for the GNU make tokenpool protocol";
    homepage = "https://github.com/milahu/gnumake-tokenpool";
    license = licenses.mit;
    maintainers = with maintainers; [ milahu ];
  };
}
