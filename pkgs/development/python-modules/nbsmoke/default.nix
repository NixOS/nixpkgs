{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jupyter_client
, ipykernel
, nbformat
, nbconvert
, pyflakes
, requests
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "nbsmoke";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eeda6c59b61130b9116a3d935e7c80ec5f617d7db8918d23289b2426efa229eb";
  };

  propagatedBuildInputs = [
    pytest
    jupyter_client
    ipykernel
    nbformat
    nbconvert
    pyflakes
    requests
    beautifulsoup4
  ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "Basic notebook checks and linting";
    homepage = https://github.com/pyviz/nbsmoke;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
