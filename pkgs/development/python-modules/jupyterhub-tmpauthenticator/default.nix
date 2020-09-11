{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, jupyterhub
}:

buildPythonPackage rec {
  pname = "jupyterhub-tmpauthenticator";
  version = "0.6";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "064x1ypxwx1l270ic97p8czbzb7swl9758v40k3w2gaqf9762f0l";
  };

  propagatedBuildInputs = [ jupyterhub ];

  # No tests available in the package
  doCheck = false;

  pythonImportsCheck = [ "tmpauthenticator" ];

  meta = with lib; {
    description = "Simple Jupyterhub authenticator that allows anyone to log in.";
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/jupyterhub/tmpauthenticator";
    maintainers = with maintainers; [ chiroptical ];
  };
}
