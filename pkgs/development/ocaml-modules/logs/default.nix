{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  version ? if lib.versionAtLeast ocaml.version "4.14" then "0.9.0" else "0.8.0",
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
        sha512 = "c34c67b00d6a989a2660204ea70db8521736d6105f15d1ee0ec6287a662798fe5c4d47075c6e7c84f5d5372adb5af5c4c404f79db70d69140af5e0ebbea3b6a5";
      };
      "0.9.0" = {
        minimalOCamlVersion = "4.14";
        sha512 = "b75fb28e83f33461b06b5c9b60972c4a9a9a1599d637b4a0c7b1e86a87f34fe5361e817cb31f42ad7e7cbb822473b28fab9f58a02870eb189ebe88dae8e045ff";
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
    inherit (param) sha512;
  };

  buildInputs = [ topkg ] ++ optional_buildInputs;

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
