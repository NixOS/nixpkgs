{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  cssselect,
  cssutils,
  lxml,
  mock,
  nose,
  requests,
  cachetools,
}:

buildPythonPackage rec {
  pname = "premailer";
  version = "3.10.0";
  format = "setuptools";
  disabled = isPy27; # no longer compatible with urllib

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0YdahBH13JK1Pvnxk9tsD4edw3jWGOCtKScj44i/5MI=";
  };

  buildInputs = [
    mock
    nose
  ];
  propagatedBuildInputs = [
    cachetools
    cssselect
    cssutils
    lxml
    requests
  ];

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = "https://github.com/peterbe/premailer";
    license = lib.licenses.bsd3;
  };
}
