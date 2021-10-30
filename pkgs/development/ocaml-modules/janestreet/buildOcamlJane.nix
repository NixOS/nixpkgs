{ buildOcaml, opaline, js_build_tools, ocaml_oasis, fetchurl } :

{ name, version ? "113.33.03", buildInputs ? [],
  hash ? "",
  minimumSupportedOcamlVersion ? "4.02", ...
}@args:

buildOcaml (args // {
  inherit name version minimumSupportedOcamlVersion;
  src = fetchurl {
    url = "https://github.com/janestreet/${name}/archive/${version}.tar.gz";
    sha256 = hash;
  };

  hasSharedObjects = true;

  buildInputs = [ ocaml_oasis js_build_tools opaline ] ++ buildInputs;

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  configurePhase = "./configure --prefix $out";

  buildPhase = "OCAML_TOPLEVEL_PATH=`ocamlfind query findlib`/.. make";

  installPhase = "opaline -prefix $prefix -libdir $OCAMLFIND_DESTDIR ${name}.install";

})
