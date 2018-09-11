{ stdenv
, buildPythonPackage
, fetchPypi
, flake8
, pep8
, pycodestyle
, mock
, pytest
}:

buildPythonPackage rec {
  version = "1.0.2";
  pname = "flake8-polyfill";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e44b087597f6da52ec6393a709e7108b2905317d0c0b744cdca6208e670d8eda";
  };

  checkInputs = [ pep8 pycodestyle mock pytest ];
  propagatedBuildInputs = [ flake8 ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/pycqa/flake8-polyfill;
    description = "Polyfill package for Flake8 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
