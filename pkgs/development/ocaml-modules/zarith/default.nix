{ stdenv, fetchurl, ocaml, findlib, pkgconfig, gmp, perl }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in
stdenv.mkDerivation rec {
  name = "zarith-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/1199/${name}.tgz";
    sha256 = "0i21bsx41br0jgw8xmlpnky5zamzqkpbykrq0z53z7ar77602s4i";
  };

  buildInputs = [ ocaml findlib pkgconfig gmp perl ];

  patchPhase = ''
    substituteInPlace ./z_pp.pl --replace '/usr/bin/perl' '${perl}/bin/perl'
  '';
  configurePhase = ''
    ./configure -installdir $out/lib/ocaml/${ocaml_version}/site-lib
  '';
  preInstall = "mkdir -p $out/lib/ocaml/${ocaml_version}/site-lib";

  meta = {
    description = "fast, arbitrary precision OCaml integers";
    homepage    = "http://forge.ocamlcore.org/projects/zarith";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = ocaml.meta.platforms;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
