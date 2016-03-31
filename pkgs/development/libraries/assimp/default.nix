{ stdenv, fetchurl, unzip, cmake, boost, zlib }:

let
  major = "3";
  minor = "1";
  revision = "1";
  version = "${major}.${minor}.${revision}";
in
stdenv.mkDerivation {
  name = "assimp-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/assimp/assimp-${major}.${minor}/assimp-${version}_no_test_models.zip";
    sha256 = "17nyzsqzqpafamhi779f1bkh5mfgj8rpas034x3v9a0hdy3jg66s";
  };

  buildInputs = [ unzip cmake boost zlib ];

  meta = with stdenv.lib; {
    description = "A library to import various 3D model formats";
    homepage = http://assimp.sourceforge.net/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ehmry ];
    platfroms = [ platforms.linux platforms.darwin ];
    inherit version;
  };
}
