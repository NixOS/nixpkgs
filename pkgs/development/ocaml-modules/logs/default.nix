{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild
, topkg, result, lwt, cmdliner, fmt
, fmtSupport ? lib.versionAtLeast ocaml.version "4.08"
, js_of_ocaml
, jsooSupport ? true
, lwtSupport ? true
, cmdlinerSupport ? true
}:
let
  pname = "logs";
  webpage = "https://erratique.ch/software/${pname}";

  optional_deps = [
    { pkg = js_of_ocaml; enable_flag = "--with-js_of_ocaml"; enabled = jsooSupport; }
    { pkg = fmt; enable_flag = "--with-fmt"; enabled = fmtSupport; }
    { pkg = lwt; enable_flag = "--with-lwt"; enabled = lwtSupport; }
    { pkg = cmdliner; enable_flag = "--with-cmdliner"; enabled = cmdlinerSupport; }
  ];
  enable_flags =
    lib.concatMap (d: [ d.enable_flag (lib.boolToString d.enabled)]) optional_deps;
  optional_buildInputs =
    map (d: d.pkg) (lib.filter (d: d.enabled) optional_deps);
in

if lib.versionOlder ocaml.version "4.03"
then throw "logs is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1jnmd675wmsmdwyb5mx5b0ac66g4c6gpv5s4mrx2j6pb0wla1x46";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ] ++ optional_buildInputs;
  propagatedBuildInputs = [ result ];

  strictDeps = true;

  buildPhase = "${topkg.run} build ${lib.escapeShellArgs enable_flags}";

  inherit (topkg) installPhase;

  meta = with lib; {
    description = "Logging infrastructure for OCaml";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
