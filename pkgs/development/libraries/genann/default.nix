{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "genann";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "codeplea";
    repo = "genann";
    rev = "v${version}";
    sha256 = "0z45ndpd4a64i6jayr4yxfcr5h87bsmhm7lfgnbp35pnfywiclmq";
  };

  dontBuild = true;
  doCheck = true;

  # Nix doesn't seem to recognize this by default.
  checkPhase = ''
    make check
  '';

  installPhase = ''
    mkdir -p $out/include
    cp ./genann.{h,c} $out/include
  '';

  meta = with lib; {
    homepage = "https://github.com/codeplea/genann";
    description = "Simple neural network library in ANSI C";
    license = licenses.zlib;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.all;
  };
}
