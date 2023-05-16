{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, nose
}:

buildPythonPackage rec {
  pname = "prison";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "betodealmeida";
    repo = "python-rison";
    rev = version;
    hash = "sha256-qor40vUQeTdlO3vwug3GGNX5vkNaF0H7EWlRdsY4bvc=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    nose
  ];

  meta = with lib; {
    description = "Rison encoder/decoder";
    homepage = "https://github.com/betodealmeida/python-rison";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
