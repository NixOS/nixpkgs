args:
args.stdenv.mkDerivation {
  name = "glib-2.14";

  src = args.fetchurl {
    url = http://ftp.acc.umu.se/pub/GNOME/sources/glib/2.14/glib-2.14.6.tar.bz2;
    sha256 = "1fi4xb07d7bfnfi65snvbi6i5kzhr3kad8knbwklj47z779vppvq";
  };

  buildInputs =(with args; [pkgconfig gettext]);
}
