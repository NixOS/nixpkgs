{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, pillow }:

buildPythonPackage rec {
  pname = "piexif";
  version = "1.1.3";
  format = "setuptools";

  # patch does not apply to PyPI sdist due to different line endings
  src = fetchFromGitHub {
    owner = "hMatoba";
    repo = "Piexif";
    rev = version;
    sha256 = "1akmaxq1cjr8wghwaaql1bd3sajl8psshl58lprgfsigrvnklp8b";
  };

  patches = [
    # Fix tests with Pillow >= 7.2.0: https://github.com/hMatoba/Piexif/pull/109
    (fetchpatch {
      url = "https://github.com/hMatoba/Piexif/commit/5209b53e9689ce28dcd045f384633378d619718f.patch";
      sha256 = "0ak571jf76r1vszp2g3cd5c16fz2zkbi43scayy933m5qdrhd8g1";
    })
  ];

  # Pillow needed for unit tests
  nativeCheckInputs = [ pillow ];

  meta = with lib; {
    description = "Simplify Exif manipulations with Python";
    homepage = "https://github.com/hMatoba/Piexif";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
