{ stdenv, buildPythonPackage, fetchPypi, pillow }:

buildPythonPackage rec {
  pname = "piexif";
  version = "1.1.3";

  # Pillow needed for unit tests
  checkInputs = [ pillow ];

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "06sz58q4mrw472p8fbnq7wsj8zpi5js5r8phm2hiwfmz0v33bjw3";
  };

  meta = with stdenv.lib; {
    broken = true;
    description = "Simplify Exif manipulations with Python";
    homepage = "https://github.com/hMatoba/Piexif";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
