{ lib, stdenv, fetchFromGitHub
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !enableStatic
}:

stdenv.mkDerivation rec {
  pname = "crypto++";
  version = "8.4.0";
  underscoredVersion = lib.strings.replaceStrings ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "weidai11";
    repo = "cryptopp";
    rev = "CRYPTOPP_${underscoredVersion}";
    sha256 = "1gwn8yh1mh41hkh6sgnhb9c3ygrdazd7645msl20i0zdvcp7f5w3";
  };

  outputs = [ "out" "dev" ];

  postPatch = ''
    substituteInPlace GNUmakefile \
        --replace "AR = libtool" "AR = ar" \
        --replace "ARFLAGS = -static -o" "ARFLAGS = -cru"

    # See https://github.com/weidai11/cryptopp/issues/1011
    substituteInPlace GNUmakefile \
      --replace "ZOPT = -O0" "ZOPT ="
  '';

  preConfigure = ''
    sh TestScripts/configure.sh
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildFlags =
       lib.optional enableStatic "static"
    ++ lib.optional enableShared "shared"
    ++ [ "libcryptopp.pc" ];
  enableParallelBuilding = true;

  doCheck = true;

  # built for checks but we don't install static lib into the nix store
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
