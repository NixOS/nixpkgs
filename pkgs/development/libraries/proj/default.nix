{ stdenv, fetchurl, cmake, sqlite }:

stdenv.mkDerivation rec {
  pname = "proj";
  version = "6.1.1";

  src = fetchurl {
    url = "https://download.osgeo.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0gsh5ng3cvz5qhd42r8j02bgs51v7xzvinryqljdgd9818va5w2w";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sqlite ];

  # Avoid attempts to fetch and build gtest for its own use:
  # (I couldn't seem to convince it to use a provided version instead)
  cmakeFlags = [ "-DPROJ_TESTS=OFF" ];

  doCheck = stdenv.is64bit;

  meta = with stdenv.lib; {
    description = "Cartographic Projections Library";
    homepage = https://proj4.org;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ vbgl ];
  };
}
