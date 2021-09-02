{ lib, fetchPypi, buildPythonPackage
, flake8, pydocstyle
, tox
}:

buildPythonPackage rec {
  pname = "flake8-docstrings";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fe7c6a306064af8e62a055c2f61e9eb1da55f84bb39caef2b84ce53708ac34b";
  };

  patchPhase = ''
    sed -i 's/py27,py35,py36,py37,py38,pypy,pypy3/py3/g' tox.ini

    sed -i 's/\[testenv\]/\[testenv\] \
    setenv   = \
    \tPYTHONPATH = {env:PYTHONPATH}{:}{toxinidir} \
    /g' tox.ini
  '';

  propagatedBuildInputs = [
    flake8
    pydocstyle
  ];

  checkInputs = [
    flake8
    tox
  ];
  checkPhase = ''
    tox
  '';

  pythonImportsCheck = [ "flake8_docstrings" ];

  meta = with lib; {
    description = "Extension for flake8 which uses pydocstyle to check docstrings";
    downloadPage = "https://pypi.org/project/flake8-docstrings/";
    homepage = "https://gitlab.com/pycqa/flake8-docstrings";
    license = licenses.mit;
    maintainers = with maintainers; [ superherointj ];
  };
}
