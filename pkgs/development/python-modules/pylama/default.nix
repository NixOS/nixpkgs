{ lib, buildPythonPackage, fetchPypi
, eradicate, mccabe, pycodestyle, pydocstyle, pyflakes
, pytest, ipdb }:

buildPythonPackage rec {
  pname = "pylama";
  version = "7.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zg7wca9s5srvbj3kawalv4438l47hg7m6gaw8rd4i43lbyyqya6";
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
