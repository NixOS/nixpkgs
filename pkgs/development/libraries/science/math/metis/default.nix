{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, gklib, llvmPackages }:

stdenv.mkDerivation (finalAttrs: {
  pname = "metis";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "METIS";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-eddLR6DvZ+2LeR0DkknN6zzRvnW+hLN2qeI+ETUPcac=";
  };

  patches = [
    # fix gklib link error
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/metis/files/metis-5.2.1-add-gklib-as-required.patch?id=c78ecbd3fdf9b33e307023baf0de12c4448dd283";
      hash = "sha256-uoXMi6pMs5VrzUmjsLlQYFLob1A8NAt9CbFi8qhQXVQ=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gklib ] ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  preConfigure = ''
    make config
  '';

  cmakeFlags = [
    (lib.cmakeFeature "GKLIB_PATH" "${gklib}")
    (lib.cmakeBool "OPENMP" true)
    (lib.cmakeBool "SHARED" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = "Serial graph partitioning and fill-reducing matrix ordering";
    homepage = "http://glaros.dtc.umn.edu/gkhome/metis/metis/overview";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
