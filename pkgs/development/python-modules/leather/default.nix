{
  lib,
  fetchPypi,
  buildPythonPackage,
  six,
  cssselect,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "leather";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZxGcKu6TvoIfB3GTvYU04pbAWzi9F02cWoDEqjHRpNM=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    cssselect
    lxml
    pytestCheckHook
  ];

  meta = {
    homepage = "http://leather.rtfd.io";
    description = "Python charting library";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
