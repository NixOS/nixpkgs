{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  requests,
  six,
  tqdm,
}:

buildPythonPackage {
  pname = "mediafire-dl";
  version = "unstable-2023-09-07";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Juvenal-Yescas";
    repo = "mediafire-dl";
    rev = "bf9d461f43c5d5dc2900e08bcd4202a597a07ca0";
    hash = "sha256-9qACTNMkO/CH/qB6WiggIKwSiFIccgU7CH0UeGUaFb4=";
  };

  propagatedBuildInputs = [
    requests
    six
    tqdm
  ];

  pythonImportsCheck = [ "mediafire_dl" ];

  meta = with lib; {
    description = "Simple command-line script to download files from mediafire based on gdown";
    homepage = "https://github.com/Juvenal-Yescas/mediafire-dl";
    license = licenses.mit;
    maintainers = with maintainers; [ euxane ];
    mainProgram = "mediafire-dl";
  };
}
