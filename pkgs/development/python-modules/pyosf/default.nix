{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pythonOlder
=======
, isPy27
, pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
}:

buildPythonPackage rec {
  pname = "pyosf";
  version = "1.0.5";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  disabled = isPy27;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "psychopy";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-Yhb6HSnLdFzWouse/RKZ8SIbMia/hhD8TAovdqmvd7o=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  preBuild = "export HOME=$TMP";

  propagatedBuildInputs = [
    requests
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "pyosf"
  ];

  meta = with lib; {
    description = "Pure Python library for simple sync with Open Science Framework";
    homepage = "https://github.com/psychopy/pyosf";
    changelog = "https://github.com/psychopy/pyosf/releases/tag/v${version}";
=======
    rev = "v${version}";
    sha256 = "1fkpmylpcbqa9ky111mz4qr1n8pik49gs7pblbb5qx6b54fzl5k2";
  };

  preBuild = "export HOME=$TMP";
  buildInputs = [ pytest-runner ];  # required via `setup_requires`
  propagatedBuildInputs = [ requests ];

  doCheck = false;  # requires network access
  pythonImportsCheck = [ "pyosf" ];

  meta = with lib; {
    homepage = "https://github.com/psychopy/pyosf";
    description = "Pure Python library for simple sync with Open Science Framework";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
