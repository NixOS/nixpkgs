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
  version = "6.1.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QAv3finMpIwxq8IQBCkyu1LcwTjvTqTVLF20KaqK5u4=";
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
