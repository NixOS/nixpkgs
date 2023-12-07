{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pexif";
  version = "0.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45a3be037c7ba8b64bbfc48f3586402cc17de55bb9d7357ef2bc99954a18da3f";
  };

  meta = with lib; {
    description = "A module for editing JPEG EXIF data";
    homepage = "http://www.benno.id.au/code/pexif/";
    license = licenses.mit;
  };

}
