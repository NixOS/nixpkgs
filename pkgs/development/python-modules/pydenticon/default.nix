{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydenticon";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-LvNjzdb08Bk85iJXSGAn42iEVw9hQLveUd5y3zIbd/E=";
  };

  propagatedBuildInputs = [
    pillow
    mock
  ];

  meta = {
    homepage = "https://github.com/azaghal/pydenticon";
    description = "Library for generating identicons. Port of Sigil (https://github.com/cupcake/sigil) with enhancements";
    license = lib.licenses.bsd0;
  };
})
