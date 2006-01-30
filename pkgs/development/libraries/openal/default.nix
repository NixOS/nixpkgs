{stdenv, fetchurl, alsaLib, autoconf, automake, libtool}:

stdenv.mkDerivation {
  name = "openal-0.0.8";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/openal-0.0.8.tar.gz;
    md5 = "0379bd39fc84454491ef38434a2e6e8d";
  };
  # Note: the autoconf/automake dependency can go once the Automake
  # patch is unnecessary.
  builder = ./builder.sh;
  patches = [./makefile.patch];
  buildInputs = [alsaLib autoconf automake libtool];
  configureFlags = ["--disable-arts" "--enable-alsa"];
}
