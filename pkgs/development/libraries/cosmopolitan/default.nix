{ lib, stdenv, fetchFromGitHub, unzip, cosmopolitan, bintools-unwrapped }:

stdenv.mkDerivation rec {
  pname = "cosmopolitan";
  version = "unstable-2022-03-22";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    rev = "5022f9e9207ff2b79ddd6de6d792d3280e12fb3a";
    sha256 = "sha256-UjL4wR5HhuXiQXg6Orcx2fKiVGRPMJk15P779BP1fRA=";
  };

  postPatch = ''
    patchShebangs build/
  '';

  dontConfigure = true;
  dontFixup = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ bintools-unwrapped unzip ];

  # slashes are significant because upstream uses o/$(MODE)/foo.o
  buildFlags = "o/cosmopolitan.h o//cosmopolitan.a o//libc/crt/crt.o o//ape/ape.o o//ape/ape.lds";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{include,lib}
    install o/cosmopolitan.h $out/include
    install o/cosmopolitan.a o/libc/crt/crt.o o/ape/ape.{o,lds} $out/lib
    runHook postInstall
  '';

  checkTarget = "o//test";
  doCheck = true;

  meta = with lib; {
    homepage = "https://justine.lol/cosmopolitan/";
    description = "Your build-once run-anywhere c library";
    platforms = platforms.x86_64;
    badPlatforms = platforms.darwin;
    license = licenses.isc;
    maintainers = with maintainers; [ lourkeur tomberek ];
  };
}
