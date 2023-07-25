{ lib, buildPythonPackage, fetchPypi, pygobject3, pythonAtLeast }:

buildPythonPackage rec {
  pname = "pydbus";
  version = "0.6.0";

  # Python 3.11 changed the API of the `inspect` module and pydbus was never
  # updated to adapt; last commit was in 2018.
  disabled = pythonAtLeast "3.11";

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
