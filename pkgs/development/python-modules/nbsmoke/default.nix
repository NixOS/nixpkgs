{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jupyter_client
, ipykernel
, holoviews
, nbformat
, nbconvert
, pyflakes
, requests
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "nbsmoke";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06as8vh17m0nkp3fpkp42m990a5zjfl2iaa17da99ksh7886mjpc";
  };

  propagatedBuildInputs = [
    pytest
    holoviews
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
    homepage = "https://github.com/pyviz/nbsmoke";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
