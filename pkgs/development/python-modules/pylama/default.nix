{ lib, buildPythonPackage, fetchPypi
, eradicate, mccabe, pycodestyle, pydocstyle, pyflakes
, pytest, ipdb }:

buildPythonPackage rec {
  pname = "pylama";
  version = "7.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9bae53ef9c1a431371d6a8dca406816a60d547147b60a4934721898f553b7d8f";
  };

  propagatedBuildInputs = [
    eradicate
    mccabe
    pycodestyle
    pydocstyle
    pyflakes
  ];

  checkInputs = [ pytest ipdb ];

  # tries to mess with the file system
  doCheck = false;

  meta = with lib; {
    description = "Code audit tool for python";
    homepage = https://github.com/klen/pylama;
    # ambiguous license declarations: https://github.com/klen/pylama/issues/64
    license = [ licenses.lgpl3 ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
