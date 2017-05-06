{lib, buildPythonPackage, fetchurl, pillow}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "piexif";
  version = "1.0.12";

  # pillow needed for unit tests
  buildInputs = [ pillow ];

  # No .tar.gz source available at PyPI, only .zip source, so need to use
  # fetchurl because fetchPypi doesn't support .zip.
  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.zip";
    sha256 = "15dvdr7b5xxsbsq5k6kq8h0xnzrkqzc08dzlih48a21x27i02bii";
  };

  meta = {
    description = "Simplify Exif manipulations with Python";
    homepage = https://github.com/hMatoba/Piexif;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
