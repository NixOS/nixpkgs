{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, openssl, boost, gmp, procps }:

stdenv.mkDerivation rec {
  pname = "libsnark";
  version = "unstable-2018-01-15";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl boost gmp ] ++ lib.optional stdenv.hostPlatform.isLinux procps;

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "-DWITH_PROCPS=OFF" "-DWITH_SUPERCOP=OFF" ];

  src = fetchFromGitHub {
    rev = "9e6b19ff15bc19fba5da1707ba18e7f160e5ed07";
    owner           = "scipr-lab";
    repo            = "libsnark";
    sha256          = "13f02qp2fmfhvxlp4xi69m0l8r5nq913l2f0zwdk7hl46lprfdca";
    fetchSubmodules = true;
  };

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "C++ library for zkSNARKs";
    homepage = "https://github.com/scipr-lab/libsnark";
    license = licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
