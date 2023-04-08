{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, ctypes, result, SDL2, pkg-config
, AudioToolbox, Cocoa, CoreAudio, CoreVideo, ForceFeedback }:

if lib.versionOlder ocaml.version "4.03"
then throw "tsdl is not available for OCaml ${ocaml.version}"
else

let
  pname = "tsdl";
  version = "1.0.0";
  webpage = "https://erratique.ch/software/${pname}";
in

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-${pname}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    hash = "sha256-XdgzCj9Uqplt/8Jk8rSFaQf8zu+9SZa8b9ZIlW/gjyE=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [ SDL2 ctypes ]
    ++ lib.optionals stdenv.isDarwin [ AudioToolbox Cocoa CoreAudio CoreVideo ForceFeedback ];

  preConfigure = ''
    # The following is done to avoid an additional dependency (ncurses)
    # due to linking in the custom bytecode runtime. Instead, just
    # compile directly into a native binary, even if it's just a
    # temporary build product.
    substituteInPlace myocamlbuild.ml \
      --replace ".byte" ".native"
  '';

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    homepage = webpage;
    description = "Thin bindings to the cross-platform SDL library";
    license = licenses.isc;
    inherit (ocaml.meta) platforms;
  };
}
