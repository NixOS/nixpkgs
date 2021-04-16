{ lib, fetchPypi, buildPythonPackage, }:

buildPythonPackage rec {
  pname = "hsluv";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/+qYspxqfSWkKW7tQAtJHIn9iTZYBqD2Ru3kTAQ3J/o=";
  };

  pythonImportsCheck = [ "hsluv" ];

  meta = with lib; {
    description = "A Python implementation of HSLuv (revision 4)";
    homepage = "https://www.hsluv.org";
    license = licenses.mit;
    maintainers = with maintainers; [ vojta001 ];
  };
}
