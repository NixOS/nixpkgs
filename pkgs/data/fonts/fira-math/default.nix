{ lib, fetchurl, stdenv }:

let
  pname = "fira-math";
  version = "0.3.4";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/firamath/firamath/releases/download/v${version}/FiraMath-Regular.otf";
    sha256 = "sha256-ICjL091NjAzxYIUg60dZlWqDpnkx17bY58MTUgGG41s=";
    name = "FiraMath-Regular.otf";
  };

  dontUnpack = true;

  installPhase = ''
    install -D $src -t $out/share/fonts/opentype/
  '';

  meta = with lib; {
    description = "Math font with Unicode math support based on FiraSans and FiraGO";
    homepage = "https://github.com/firamath/firamath";
    license = licenses.ofl;
    maintainers = [ maintainers.loicreynier ];
    platforms = platforms.all;
  };
}
