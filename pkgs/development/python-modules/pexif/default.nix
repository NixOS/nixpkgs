{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pexif";
  version = "0.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45a3be037c7ba8b64bbfc48f3586402cc17de55bb9d7357ef2bc99954a18da3f";
  };

<<<<<<< HEAD
  meta = {
    description = "Module for editing JPEG EXIF data";
    homepage = "http://www.benno.id.au/code/pexif/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Module for editing JPEG EXIF data";
    homepage = "http://www.benno.id.au/code/pexif/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
