{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
, mock
}:

buildPythonPackage rec {
  pname = "pydenticon";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "035dawcspgjw2rksbnn863s7b0i9ac8cc1nshshvd1l837ir1czp";
  };

  propagatedBuildInputs = [ pillow mock ];

  meta = with stdenv.lib; {
    homepage = https://github.com/azaghal/pydenticon;
    description = "Library for generating identicons. Port of Sigil (https://github.com/cupcake/sigil) with enhancements";
    license = licenses.bsd0;
  };

}
