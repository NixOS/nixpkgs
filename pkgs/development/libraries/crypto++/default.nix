{ stdenv, fetchFromGitHub, nasm, which }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "crypto++";
  version = "8.2.0";
  underscoredVersion = strings.replaceStrings ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "weidai11";
    repo = "cryptopp";
    rev = "CRYPTOPP_${underscoredVersion}";
    sha256 = "01zrrzjn14yhkb9fzzl57vmh7ig9a6n6fka45f8za0gf7jpcq3mj";
  };

  postPatch = ''
    substituteInPlace GNUmakefile \
        --replace "AR = libtool" "AR = ar" \
        --replace "ARFLAGS = -static -o" "ARFLAGS = -cru"
  '';

  nativeBuildInputs = optionals stdenv.hostPlatform.isx86 [ nasm which ];

  preBuild = optionalString stdenv.hostPlatform.isx86 "${stdenv.shell} rdrand-nasm.sh";
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildFlags = [ "shared" "libcryptopp.pc" ];
  enableParallelBuilding = true;

  doCheck = true;

  preInstall = "rm libcryptopp.a"; # built for checks but we don't install static lib into the nix store
  installTargets = [ "install-lib" ];
  installFlags = [ "LDCONF=true" ];
  postInstall = optionalString (!stdenv.hostPlatform.isDarwin) ''
    ln -sr $out/lib/libcryptopp.so.${version} $out/lib/libcryptopp.so.${versions.majorMinor version}
    ln -sr $out/lib/libcryptopp.so.${version} $out/lib/libcryptopp.so.${versions.major version}
  '';

  meta = {
    description = "Crypto++, a free C++ class library of cryptographic schemes";
    homepage = "https://cryptopp.com/";
    changelog = "https://raw.githubusercontent.com/weidai11/cryptopp/CRYPTOPP_${underscoredVersion}/History.txt";
    license = with licenses; [ boost publicDomain ];
    platforms = platforms.all;
    maintainers = with maintainers; [ c0bw3b ];
  };
}
