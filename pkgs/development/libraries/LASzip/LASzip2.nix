{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "2.2.0";
  pname = "LASzip";

  src = fetchurl {
    url = "https://github.com/LASzip/LASzip/archive/v${version}.tar.gz";
    sha256 = "b8e8cc295f764b9d402bc587f3aac67c83ed8b39f1cb686b07c168579c61fbb2";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Turn quickly bulky LAS files into compact LAZ files without information loss";
    homepage = "https://laszip.org";
    license = licenses.lgpl2;
    maintainers = [ maintainers.michelk ];
    platforms = platforms.unix;
  };
}
