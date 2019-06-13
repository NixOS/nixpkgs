{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "LASzip-${version}";

  src = fetchurl {
    url = "https://github.com/LASzip/LASzip/archive/v${version}.tar.gz";
    sha256 = "b8e8cc295f764b9d402bc587f3aac67c83ed8b39f1cb686b07c168579c61fbb2";
  };

  buildInputs = [cmake];

  meta = {
    description = "Turn quickly bulky LAS files into compact LAZ files without information loss";
    homepage = https://laszip.org;
    license = stdenv.lib.licenses.lgpl2;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = stdenv.lib.platforms.unix;
  };
}
