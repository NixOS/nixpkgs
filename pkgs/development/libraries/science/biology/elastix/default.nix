{ stdenv, fetchFromGitHub, fetchpatch, cmake, itk, python3 }:

stdenv.mkDerivation rec {
  pname    = "elastix";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner  = "SuperElastix";
    repo   = pname;
    rev    = version;
    sha256 = "1zrl7rz4lwsx88b2shnl985f3a97lmp4ksbd437h9y0hfjq8l0lj";
  };

  patches = [
    (fetchpatch {
      name = "itk-5.1-compat.patch";
      url = "https://github.com/SuperElastix/elastix/commit/402e9a26f22f805b8f2db00c00e59f75fa1783ad.patch";
      sha256 = "1il6gc1lgy78i0w6gkkppr61nh6g0yjspbfk19hcz20778m5jhz9";
    })
    (fetchpatch {
      name = "fix-osx-build.patch";
      url = "https://github.com/SuperElastix/elastix/commit/52e1dc3928046f9fbb85d4b2ecd0d5175fa9695d.patch";
      sha256 = "1hf7kgx1jv497pf0x5wj79sy1wncxcvhrkix9w086lcr8zwxvn9q";
    })
  ];


  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ itk ];

  doCheck = !stdenv.isDarwin;  # usual dynamic linker issues

  preCheck = "
    export LD_LIBRARY_PATH=$(pwd)/bin
  ";

  meta = with stdenv.lib; {
    homepage = "http://elastix.isi.uu.nl/";
    description = "Image registration toolkit based on ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.x86_64;  # libitkpng linker issues with ITK 5.1
    license = licenses.asl20;
  };
}
