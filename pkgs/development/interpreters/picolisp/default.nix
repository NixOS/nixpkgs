{
  clang,
  fetchurl,
  lib,
  libffi,
  llvm,
  makeWrapper,
  openssl,
  pkg-config,
  readline,
  stdenv
}:

stdenv.mkDerivation {
  pname = "PicoLisp";
  version = "24.3.30";
  src = fetchurl {
    url = "https://www.software-lab.de/picoLisp-24.3.tgz";
    sha256 = "sha256-FB43DAjHBFgxdysoLzBXLxii52a2CCh1skZP/RTzfdc=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ clang libffi llvm openssl pkg-config readline ];
  sourceRoot = ''pil21'';
  buildPhase = ''
    cd src
    make
  '';

  installPhase = ''
    cd ..
    mkdir -p "$out/lib" "$out/bin" "$out/man"
    cp -r . "$out/lib/picolisp/"
    ln -s "$out/lib/picolisp/bin/picolisp" "$out/bin/picolisp"
    ln -s "$out/lib/picolisp/bin/pil" "$out/bin/pil"
    ln -s "$out/lib/picolisp/man/man1/pil.1" "$out/man/pil.1"
    ln -s "$out/lib/picolisp/man/man1/picolisp.1" "$out/man/picolisp.1"
    substituteInPlace $out/bin/pil --replace /usr $out
  '';

  meta = with lib; {
    description = "A pragmatic programming language.";
    homepage = "https://picolisp.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ nat-418 ];
    platforms = platforms.all;
  };
}

