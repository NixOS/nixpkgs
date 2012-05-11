{ stdenv }:

stdenv.mkDerivation rec {
  name = "perl";

  unpackPhase = "true";
  
  installPhase =
    ''
      mkdir -p $out/bin
      ln -s /usr/bin/perl $out/bin
    '';

  setupHook = ./setup-hook.sh;

  libPrefix = "lib/perl5/site_perl/5.10/i686-cygwin";

  passthru.libPrefix = libPrefix;
}
