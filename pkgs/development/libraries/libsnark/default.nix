{ stdenv, fetchFromGitHub, cmake, pkgconfig, openssl, boost, gmp, procps }:

let
  rev = "9e6b19ff15bc19fba5da1707ba18e7f160e5ed07";
  inherit (stdenv) lib;
in stdenv.mkDerivation rec {
  name = "libsnark-pre${version}";
  version = stdenv.lib.substring 0 8 rev;

  buildInputs = [ cmake pkgconfig openssl boost gmp ] ++ lib.optional stdenv.hostPlatform.isLinux procps;

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "-DWITH_PROCPS=OFF" "-DWITH_SUPERCOP=OFF" ];

  src = fetchFromGitHub {
    inherit rev;
    owner           = "scipr-lab";
    repo            = "libsnark";
    sha256          = "13f02qp2fmfhvxlp4xi69m0l8r5nq913l2f0zwdk7hl46lprfdca";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ library for zkSNARKs";
    homepage = https://github.com/scipr-lab/libsnark;
    license = licenses.mit;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
