{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, openssl, boost, gmp, procps }:

let
  rev = "9e6b19ff15bc19fba5da1707ba18e7f160e5ed07";
in stdenv.mkDerivation rec {
  name = "libsnark-pre${version}";
  version = lib.substring 0 8 rev;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl boost gmp ] ++ lib.optional stdenv.hostPlatform.isLinux procps;

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "-DWITH_PROCPS=OFF" "-DWITH_SUPERCOP=OFF" ];

  src = fetchFromGitHub {
    inherit rev;
    owner           = "scipr-lab";
    repo            = "libsnark";
    sha256          = "13f02qp2fmfhvxlp4xi69m0l8r5nq913l2f0zwdk7hl46lprfdca";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "C++ library for zkSNARKs";
    homepage = "https://github.com/scipr-lab/libsnark";
    license = licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
