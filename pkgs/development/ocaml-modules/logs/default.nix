{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  version ? if lib.versionAtLeast ocaml.version "4.14" then "0.10.0" else "0.8.0",
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
}:
let
  param =
    {
      "0.8.0" = {
        minimalOCamlVersion = "4.03";
        hash = "sha256-mmFRQJX6QvMBIzJiO2yNYF1Ce+qQS2oNF3+OwziCNtg=";
      };
      "0.10.0" = {
        minimalOCamlVersion = "4.14";
        hash = "sha256-dg7CkcEo11t0gmCRM3dk+SW1ykFLAuLTNqCze/MN9Oo=";
      };
    }
    .${version};

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
buildTopkgPackage {
  inherit pname version;
  inherit (param) minimalOCamlVersion;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    inherit (param) hash;
  };

  buildInputs = optional_buildInputs;

  buildPhase = "${topkg.run} build ${lib.escapeShellArgs enable_flags}";

  meta = {
    description = "Logging infrastructure for OCaml";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    maintainers = with lib.maintainers; [ sternenseemann ];
    license = lib.licenses.isc;
  };
}
