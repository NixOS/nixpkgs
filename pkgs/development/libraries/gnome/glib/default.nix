{input, stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig gettext perl];
}
