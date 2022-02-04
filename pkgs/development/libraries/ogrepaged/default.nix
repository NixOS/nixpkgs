{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, ois, ogre, libX11, boost }:

stdenv.mkDerivation rec {
  pname = "ogre-paged";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "ogre-pagedgeometry";
    rev = "v${version}";
    sha256 = "sha256-EwtTV8cbhDv0Bgj7i3qgq4hLETwd5B2GFEegwozlY9U=";
  };

  patches = [
    # These patches come from https://github.com/RigsOfRods/ogre-pagedgeometry/pull/6
    # and make ogre-paged build with ogre-1.10.
    (fetchpatch {
      url = "https://github.com/RigsOfRods/ogre-pagedgeometry/commit/2d4df577decba37ec3cdafc965deae0f6d31fe45.patch";
      sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
    })
    (fetchpatch {
      url = "https://github.com/RigsOfRods/ogre-pagedgeometry/commit/4d81789ec6f55e294a5ad040ea7abe2b415cbc92.patch";
      sha256 = "17q8djdz2y3g46azxc3idhyvi6vf0sqkxld4bbyp3l9zn7dq76rp";
    })
    (fetchpatch {
      url = "https://github.com/RigsOfRods/ogre-pagedgeometry/commit/10f7c5ce5b422e9cbac59d466f3567a24c8831a4.patch";
      sha256 = "1kk0dbadzg73ai99l3w04q51sil36vzbkaqc79mdwy0vjrn4ardb";
    })
  ];

  buildInputs = [ ois ogre libX11 boost ];
  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [ "-DPAGEDGEOMETRY_BUILD_SAMPLES=OFF" ];

  meta = {
    description = "Paged Geometry for Ogre3D";
    homepage = "https://github.com/RigsOfRods/ogre-paged";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
