{ lib
, stdenv
, fetchFromGitHub
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !enableStatic
# Multi-threading with OpenMP is disabled by default
# more info on https://www.cryptopp.com/wiki/OpenMP
, withOpenMP ? false
, llvmPackages
}:

stdenv.mkDerivation rec {
  pname = "crypto++";
  version = "8.6.0";
  underscoredVersion = lib.strings.replaceStrings ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "weidai11";
    repo = "cryptopp";
    rev = "CRYPTOPP_${underscoredVersion}";
    hash = "sha256-a3TYaK34WvKEXN7LKAfGwQ3ZL6a3k/zMZyyVfnkQqO4=";
  };

  outputs = [ "out" "dev" ];

  postPatch = ''
    substituteInPlace GNUmakefile \
      --replace "AR = /usr/bin/libtool" "AR = ar" \
      --replace "ARFLAGS = -static -o" "ARFLAGS = -cru"
  '';

  buildInputs = lib.optionals (stdenv.cc.isClang && withOpenMP) [ llvmPackages.openmp ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  buildFlags =
       lib.optional enableStatic "static"
    ++ lib.optional enableShared "shared"
    ++ [ "libcryptopp.pc" ];

  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ];
  CXXFLAGS = lib.optionals (withOpenMP) [ "-fopenmp" ];

  doCheck = true;

  # always built for checks but install static lib only when necessary
  preInstall = lib.optionalString (!enableStatic) "rm -f libcryptopp.a";

  installTargets = [ "install-lib" ];
  installFlags = [ "LDCONF=true" ];
  # TODO: remove postInstall hook with v8.7 -> https://github.com/weidai11/cryptopp/commit/230c558a
  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    ln -sr $out/lib/libcryptopp.so.${version} $out/lib/libcryptopp.so.${lib.versions.majorMinor version}
    ln -sr $out/lib/libcryptopp.so.${version} $out/lib/libcryptopp.so.${lib.versions.major version}
  '';

  meta = with lib; {
    description = "A free C++ class library of cryptographic schemes";
    homepage = "https://cryptopp.com/";
    changelog = [
      "https://raw.githubusercontent.com/weidai11/cryptopp/CRYPTOPP_${underscoredVersion}/History.txt"
      "https://github.com/weidai11/cryptopp/releases/tag/CRYPTOPP_${underscoredVersion}"
    ];
    license = with licenses; [ boost publicDomain ];
    platforms = platforms.all;
    maintainers = with maintainers; [ c0bw3b ];
  };
}
