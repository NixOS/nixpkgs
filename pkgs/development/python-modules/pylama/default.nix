{ lib, buildPythonPackage, fetchPypi
, eradicate, mccabe, pycodestyle, pydocstyle, pyflakes
, pytest, ipdb }:

buildPythonPackage rec {
  pname = "pylama";
  version = "7.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f81bf3bbd15db802b620903df491e5cd6469dcd542424ce6718425037dcc4d10";
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
