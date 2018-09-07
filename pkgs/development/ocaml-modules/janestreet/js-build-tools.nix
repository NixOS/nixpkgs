{ stdenv, buildOcaml, fetchurl, ocaml_oasis, opaline }:

buildOcaml rec {
  name = "js-build-tools";
  version = "113.33.06";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/${name}/archive/${version}.tar.gz";
    sha256 = "1nvgyp4gsnlnpix3li6kr90b12iin5ihichv298p03i6h2809dia";
  };

  hasSharedObjects = true;

  buildInputs = [ ocaml_oasis opaline ];

  dontAddPrefix = true;
  configurePhase = "./configure --prefix $prefix";
  installPhase = "opaline -prefix $prefix -libdir $OCAMLFIND_DESTDIR ${name}.install";

  patches = [ ./js-build-tools-darwin.patch ];

  meta = with stdenv.lib; {
    description = "Jane Street Build Tools";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
