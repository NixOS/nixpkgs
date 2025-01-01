{ lib, stdenv, fetchurl, zlib, unzip }:

stdenv.mkDerivation rec {
  pname = "libipasirglucose4";
  # This library has no version number AFAICT (beyond generally being based on
  # Glucose 4.x), but it was submitted to the 2017 SAT competition so let's use
  # that as the version number, I guess.
  version = "2017";

  libname = pname + stdenv.hostPlatform.extensions.sharedLibrary;

  src = fetchurl {
    url = "https://baldur.iti.kit.edu/sat-competition-2017/solvers/incremental/glucose-ipasir.zip";
    sha256 = "0xchgady9vwdh8frmc8swz6va53igp2wj1y9sshd0g7549n87wdj";
  };
  nativeBuildInputs = [ unzip ];

  buildInputs = [ zlib ];

  sourceRoot = "sat/glucose4";
  patches = [ ./0001-Support-shared-library-build.patch ];

  makeFlags = [ "CXX=${stdenv.cc.targetPrefix}c++" ];

  postBuild = ''
    $CXX -shared -o ${libname} \
        ${lib.optionalString (!stdenv.cc.isClang) "-Wl,-soname,${libname}"} \
        ipasirglucoseglue.o libipasirglucose4.a
  '';

  installPhase = ''
    install -D ${libname} $out/lib/${libname}
  '';

  meta = with lib; {
    description = "Shared library providing IPASIR interface to the Glucose SAT solver";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kini ];
  };
}
