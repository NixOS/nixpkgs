{ lib, stdenv, gcc, gnumake, fetchgit }:

let
  crazyStr = (lib.strings.escapeShellArg "\${0%/*}");
in

stdenv.mkDerivation rec {
  pname = "MiniPicoLisp";
  version = "2024-04-12";
   src = fetchgit {
    url = "https://github.com/nat-418/MiniPicoLisp";
    rev = version;
    sha256 = "sha256-6uqXPgF43cj/RfN5ti7PoAwUZUUCnN+Z3A53+ANTPc8=";
  };

  nativeBuildInputs = [ gcc gnumake ];

  buildPhase = ''
    rm *.nix
    cd src
    make
    cd ..
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r . "$out"
    ln -s "$out/mpil" "$out/bin/mpil"
    substituteInPlace $out/bin/mpil --replace ${crazyStr} $out
  '';

  meta = with lib; {
    description = ''An embeddable, "pure" PicoLisp interpreter.'';
    homepage = "https://www.picolisp.com/wiki/?embedded";
    license = licenses.mit;
    maintainers = with maintainers; [ nat-418 ];
    platforms = platforms.all;
  };
}

