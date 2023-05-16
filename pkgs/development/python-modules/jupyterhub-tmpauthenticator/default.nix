{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, jupyterhub
}:

buildPythonPackage rec {
  pname = "jupyterhub-tmpauthenticator";
<<<<<<< HEAD
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7TuAYP6mRffsZL+O+AMgt5HBu6PhwLYj5A8X8DnMfl0=";
  };

  propagatedBuildInputs = [
    jupyterhub
  ];
=======
  version = "0.6";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "064x1ypxwx1l270ic97p8czbzb7swl9758v40k3w2gaqf9762f0l";
  };

  propagatedBuildInputs = [ jupyterhub ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # No tests available in the package
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "tmpauthenticator"
  ];

  meta = with lib; {
    description = "Simple Jupyterhub authenticator that allows anyone to log in";
    homepage = "https://github.com/jupyterhub/tmpauthenticator";
    changelog = "https://github.com/jupyterhub/tmpauthenticator/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
=======
  pythonImportsCheck = [ "tmpauthenticator" ];

  meta = with lib; {
    description = "Simple Jupyterhub authenticator that allows anyone to log in.";
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/jupyterhub/tmpauthenticator";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ chiroptical ];
  };
}
