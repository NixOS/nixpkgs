{ stdenv, buildPythonPackage, fetchPypi, pillow }:

buildPythonPackage rec {
  pname = "piexif";
  version = "1.1.2";

  # Pillow needed for unit tests
  checkInputs = [ pillow ];

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0dj6wiw4mk65zn7p0qpghra39mf88m3ph2xn7ff9jvasgczrgkb0";
  };

  meta = with stdenv.lib; {
    description = "Simplify Exif manipulations with Python";
    homepage = https://github.com/hMatoba/Piexif;
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
