{ lib, stdenv, fetchFromGitHub
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !enableStatic
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
      --replace "AR = libtool" "AR = ar" \
      --replace "ARFLAGS = -static -o" "ARFLAGS = -cru"
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildFlags =
       lib.optional enableStatic "static"
    ++ lib.optional enableShared "shared"
    ++ [ "libcryptopp.pc" ];
  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ];

  doCheck = true;

  # always built for checks but install static lib only when necessary
  preInstall = lib.optionalString (!enableStatic) "rm libcryptopp.a";

  installTargets = [ "install-lib" ];
  installFlags = [ "LDCONF=true" ];
  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    ln -sr $out/lib/libcryptopp.so.${version} $out/lib/libcryptopp.so.${lib.versions.majorMinor version}
    ln -sr $out/lib/libcryptopp.so.${version} $out/lib/libcryptopp.so.${lib.versions.major version}
  '';

  meta = {
    description = "Crypto++, a free C++ class library of cryptographic schemes";
    homepage = "https://cryptopp.com/";
    changelog = "https://raw.githubusercontent.com/weidai11/cryptopp/CRYPTOPP_${underscoredVersion}/History.txt";
    license = with lib.licenses; [ boost publicDomain ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ c0bw3b ];
  };
}
