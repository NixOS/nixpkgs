{stdenv, lib, fetchurl, ocaml, findlib, camlp4}:

if lib.versionAtLeast ocaml.version "4.05"
then throw "camomile-0.8.2 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "camomile";
  version = "0.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/camomile/camomile-${version}.tar.bz2";
    sha256 = "0x43pjxx70kgip86mmdn08s97k4qzdqc8i79xfyyx28smy1bsa00";
  };

  nativeBuildInputs = [ ocaml findlib camlp4 ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = {
    homepage = "http://camomile.sourceforge.net/";
    description = "A comprehensive Unicode library for OCaml";
    license = lib.licenses.lgpl21;
    branch = "0.8.2";
    inherit (ocaml.meta) platforms;
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
