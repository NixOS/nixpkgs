{ stdenv }:

stdenv.mkDerivation {
  name = "perl";

  unpackPhase = "true";
  
  installPhase =
    ''
      mkdir -p $out/bin
      ln -s /usr/bin/perl $out/bin
    '';

  setupHook = ./setup-hook.sh;
}
