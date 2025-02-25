{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  jupyterhub,
}:

buildPythonPackage rec {
  pname = "jupyterhub-tmpauthenticator";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7TuAYP6mRffsZL+O+AMgt5HBu6PhwLYj5A8X8DnMfl0=";
  };

  propagatedBuildInputs = [ jupyterhub ];

  # No tests available in the package
  doCheck = false;

  pythonImportsCheck = [ "tmpauthenticator" ];

  meta = with lib; {
    description = "Simple Jupyterhub authenticator that allows anyone to log in";
    homepage = "https://github.com/jupyterhub/tmpauthenticator";
    changelog = "https://github.com/jupyterhub/tmpauthenticator/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ chiroptical ];
  };
}
