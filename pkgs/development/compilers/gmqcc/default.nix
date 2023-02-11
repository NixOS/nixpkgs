{ lib
, pkgs
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "gmqcc";
  version = "unstable-2021-07-09";

  src = fetchFromGitHub {
    owner = "graphitemaster";
    repo = "gmqcc";
    rev = "297eab9e5e2c9cc4f41201b68821593a5cf9a725";
    sha256 = "1hl2qn7402ia03kjkblj4q4wfypxkil99sivsyk2vrnwwpdp4nzx";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 gmqcc $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://graphitemaster.github.io/gmqcc/";
    description = "A modern QuakeC compiler";
    longDescription = ''
      For an enduring period of time the options for a decent compiler for
      the Quake C programming language were confined to a specific compiler
      known as QCC. Attempts were made to extend and improve upon the design
      of QCC, but many foreseen the consequences of building on a broken
      foundation. The solution was obvious, a new compiler; one born from
      the NIH realm of sarcastic wit.
      We welcome you. You won't find a better Quake C compiler.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ necrophcodr ];
    platforms = platforms.linux;
  };
}
