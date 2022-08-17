{ lib, buildPythonPackage, fetchPypi, pygobject3 }:

buildPythonPackage rec {
  pname = "pydbus";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b0gipvz7vcfa9ddmwq2jrx16d4apb0hdnl5q4i3h8jlzwp1c1s2";
  };

  propagatedBuildInputs = [ pygobject3 ];

  pythonImportsCheck = [ "pydbus" ];

  meta = {
    homepage = "https://github.com/LEW21/pydbus";
    description = "Pythonic DBus library";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
