{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, jupyterhub
}:

buildPythonPackage rec {
  pname = "jupyterhub-tmpauthenticator";
  version = "1.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7TuAYP6mRffsZL+O+AMgt5HBu6PhwLYj5A8X8DnMfl0=";
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
