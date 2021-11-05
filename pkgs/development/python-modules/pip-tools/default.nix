{ lib
, fetchPypi
, pythonOlder
, buildPythonPackage
, pip
, pytest
, pytest-xdist
, click
, setuptools-scm
, git
, glibcLocales
, mock
, pep517
}:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "6.3.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "992d968df6f1a19d4d37c53b68b3d4b601b894fb3ee0926d1fa762ebc7c7e9e9";
  };

  LC_ALL = "en_US.UTF-8";
  checkInputs = [ pytest git glibcLocales mock pytest-xdist ];
  propagatedBuildInputs = [ pip click setuptools-scm pep517 ];

  checkPhase = ''
    export HOME=$(mktemp -d) VIRTUAL_ENV=1
    py.test -m "not network"
  '';

  meta = with lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
