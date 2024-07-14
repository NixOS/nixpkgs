{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  mock,
}:

buildPythonPackage rec {
  pname = "pydenticon";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LvNjzdb08Bk85iJXSGAn42iEVw9hQLveUd5y3zIbd/E=";
  };

  propagatedBuildInputs = [
    pillow
    mock
  ];

  meta = with lib; {
    homepage = "https://github.com/azaghal/pydenticon";
    description = "Library for generating identicons. Port of Sigil (https://github.com/cupcake/sigil) with enhancements";
    license = licenses.bsd0;
  };
}
