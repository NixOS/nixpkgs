{ stdenv, fetchurl, pkgconfig, efl, elementary }:
stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "0.9.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.xz";
    sha256 = "1kwv9vkhngdm5v38q93xpcykghnyawhjjcb5bgy0p89gpbk7mvpc";
  };
  buildInputs = [ pkgconfig efl elementary ];
  meta = {
    description = "The best terminal emulator written with the EFL";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
