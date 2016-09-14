{ buildOcaml, opam, js_build_tools, ocaml_oasis, fetchurl } :

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

  buildInputs = [ ocaml_oasis js_build_tools opam ] ++ buildInputs;

  dontAddPrefix = true;

  configurePhase = "./configure --prefix $out";

  buildPhase = "OCAML_TOPLEVEL_PATH=`ocamlfind query findlib`/.. make";

  installPhase = ''
    opam-installer -i --prefix $prefix --libdir `ocamlfind printconf destdir` --stubsdir `ocamlfind printconf destdir`/${name} ${name}.install
    if [ -d $out/lib/${name} ]
      then if [ "$(ls -A $out/lib/${name})" ]
        then mv $out/lib/${name}/* `ocamlfind printconf destdir`/${name}
      fi
      rmdir $out/lib/${name}
    fi
  '';

})
