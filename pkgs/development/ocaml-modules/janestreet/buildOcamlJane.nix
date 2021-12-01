{ buildOcaml, opaline, js_build_tools, ocaml_oasis, fetchFromGitHub } :

{ pname, version ? "113.33.03", buildInputs ? [],
  hash ? "",
  minimumSupportedOcamlVersion ? "4.02", ...
}@args:

buildOcaml (args // {
  inherit pname version minimumSupportedOcamlVersion;
  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = version;
    sha256 = hash;
  };

  hasSharedObjects = true;

  buildInputs = [ ocaml_oasis js_build_tools opaline ] ++ buildInputs;

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  configurePhase = ''
    ./configure --prefix $out
  '';

  buildPhase = ''
    OCAML_TOPLEVEL_PATH=`ocamlfind query findlib`/.. make
  '';

  installPhase = ''
    opaline -prefix $prefix -libdir $OCAMLFIND_DESTDIR ${pname}.install
  '';

})
