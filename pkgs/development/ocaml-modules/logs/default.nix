{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  topkg,
  buildTopkgPackage,
  cmdlinerSupport ? true,
  cmdliner,
  fmtSupport ? lib.versionAtLeast ocaml.version "4.08",
  fmt,
  jsooSupport ? true,
  js_of_ocaml-compiler,
  lwtSupport ? true,
  lwt,
  result,
}:
let
  pname = "logs";
  webpage = "https://erratique.ch/software/${pname}";

  optional_deps = [
    {
      pkg = js_of_ocaml-compiler;
      enable_flag = "--with-js_of_ocaml-compiler";
      enabled = jsooSupport;
    }
    {
      pkg = fmt;
      enable_flag = "--with-fmt";
      enabled = fmtSupport;
    }
    {
      pkg = lwt;
      enable_flag = "--with-lwt";
      enabled = lwtSupport;
    }
    {
      pkg = cmdliner;
      enable_flag = "--with-cmdliner";
      enabled = cmdlinerSupport;
    }
  ];
  enable_flags = lib.concatMap (d: [
    d.enable_flag
    (lib.boolToString d.enabled)
  ]) optional_deps;
  optional_buildInputs = map (d: d.pkg) (lib.filter (d: d.enabled) optional_deps);
in

buildTopkgPackage rec {
  inherit pname;
  version = "0.8.0";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    hash = "sha256-mmFRQJX6QvMBIzJiO2yNYF1Ce+qQS2oNF3+OwziCNtg=";
  };

  buildInputs = [ topkg ] ++ optional_buildInputs;
  propagatedBuildInputs = [ result ];

  strictDeps = true;

  buildPhase = "${topkg.run} build ${lib.escapeShellArgs enable_flags}";

  meta = with lib; {
    description = "Logging infrastructure for OCaml";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
