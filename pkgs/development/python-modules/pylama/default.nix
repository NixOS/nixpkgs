{ lib, buildPythonPackage, fetchPypi
, eradicate, mccabe, pycodestyle, pydocstyle, pyflakes
, pytest, ipdb }:

buildPythonPackage rec {
  pname = "pylama";
  version = "7.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0277pr066vg1w8ip6kdava7d5daiv7csixpysb37ss140k222iiv";
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
