{ stdenv, fetchurl, ocaml, findlib, ctypes, result, SDL2, pkgconfig, opam }:

let
  inherit (stdenv.lib) getVersion;

  pname = "tsdl";
  version = "0.9.0";
  webpage = "http://erratique.ch/software/${pname}";

in

stdenv.mkDerivation {
  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "02x0wsy5nxagxrh07yb2h4yqqy1bxryp2gwrylds0j6ybqsv4shm";
  };

  buildInputs = [ ocaml findlib result pkgconfig opam ];
  propagatedBuildInputs = [ SDL2 ctypes ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = ''
    # The following is done to avoid an additional dependency (ncurses)
    # due to linking in the custom bytecode runtime. Instead, just
    # compile directly into a native binary, even if it's just a
    # temporary build product.
    substituteInPlace myocamlbuild.ml \
      --replace ".byte" ".native"

    ocaml pkg/build.ml native=true native-dynlink=true
  '';

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install | sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${getVersion ocaml}/site-lib/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = "${webpage}";
    description = "Thin bindings to the cross-platform SDL library";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
  };
}
