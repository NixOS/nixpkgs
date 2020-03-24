{ fetchFromGitHub, zlib, stdenv }:
let
  libs-src = fetchFromGitHub {
    owner = "megatokio";
    repo = "Libraries";
    rev = "97ea480051b106e83a086dd42583dfd3e9d458a1";
    sha256 = "1kqmjb9660mnb0r18s1grrrisx6b73ijsinlyr97vz6992jd5dzh";
  };
in
stdenv.mkDerivation {
  pname = "zasm";
  version = "4.2.6";
  src = fetchFromGitHub {
    owner = "megatokio";
    repo = "zasm";
    rev = "f1424add17a5514895a598d6b5e3982579961519";
    sha256 = "1kqnqdqp2bfsazs6vfx2aiqanxxagn8plx8g6rc11vmr8yqnnpks";
  };

  buildInputs = [ zlib ];

  configurePhase = ''
    ln -sf ${libs-src} Libraries
  '';

  buildPhase = ''
    cd Linux
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv zasm $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Z80 / 8080 assembler (for unix-style OS)";
    homepage = "https://k1.spdns.de/Develop/Projects/zasm/Distributions/";
    license = licenses.bsd2;
    maintainers = [ maintainers.turbomack ];
    platforms = platforms.linux;
    badPlatforms = platforms.aarch64;
  };
}
