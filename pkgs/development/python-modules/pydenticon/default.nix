{ lib
, buildPythonPackage
, fetchPypi
, pillow
, mock
}:

buildPythonPackage rec {
  pname = "pydenticon";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ef363cdd6f4f0193ce62257486027e36884570f6140bbde51de72df321b77f1";
  };

  propagatedBuildInputs = [ pillow mock ];

  meta = with lib; {
    homepage = "https://github.com/azaghal/pydenticon";
    description = "Library for generating identicons. Port of Sigil (https://github.com/cupcake/sigil) with enhancements";
    license = licenses.bsd0;
  };

}
