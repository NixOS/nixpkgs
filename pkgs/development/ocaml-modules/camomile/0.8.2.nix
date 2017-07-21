{stdenv, fetchurl, ocaml, findlib, camlp4}:

if stdenv.lib.versionAtLeast ocaml.version "4.05"
then throw "camomile-0.8.2 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "camomile-${version}";
  version = "0.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/camomile/camomile-${version}.tar.bz2";
    sha256 = "0x43pjxx70kgip86mmdn08s97k4qzdqc8i79xfyyx28smy1bsa00";
  };

  buildInputs = [ocaml findlib camlp4];

  createFindlibDestdir = true;

  meta = {
    homepage = http://camomile.sourceforge.net/;
    description = "A comprehensive Unicode library for OCaml";
    license = stdenv.lib.licenses.lgpl21;
    branch = "0.8.2";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
