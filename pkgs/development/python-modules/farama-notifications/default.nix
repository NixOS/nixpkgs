{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "farama-notifications";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "farama-notifications";
    rev = version;
    hash = "sha256-UUrJ/5t5x54xs1gweNUhwqrMJQXiyrUPn1bBfTsiPcw=";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "farama_notifications" ];

<<<<<<< HEAD
  meta = {
    description = "Allows for providing notifications on import to all Farama Packages";
    homepage = "https://github.com/Farama-Foundation/Farama-Notifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
=======
  meta = with lib; {
    description = "Allows for providing notifications on import to all Farama Packages";
    homepage = "https://github.com/Farama-Foundation/Farama-Notifications";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
