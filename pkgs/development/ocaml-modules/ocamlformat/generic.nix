{ lib, fetchurl, ocaml-ng, version }:

# The ocamlformat package have been split into two in version 0.25.1:
# one for the library and one for the executable.
# Both have the same sources and very similar dependencies.

with ocaml-ng.ocamlPackages;

rec {
  tarballName = "ocamlformat-${version}.tbz";

  src = fetchurl {
    url =
      "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/${tarballName}";
    sha256 = {
      "0.19.0" = "0ihgwl7d489g938m1jvgx8azdgq9f5np5mzqwwya797hx2m4dz32";
      "0.20.0" = "sha256-JtmNCgwjbCyUE4bWqdH5Nc2YSit+rekwS43DcviIfgk=";
      "0.20.1" = "sha256-fTpRZFQW+ngoc0T6A69reEUAZ6GmHkeQvxspd5zRAjU=";
      "0.21.0" = "sha256-KhgX9rxYH/DM6fCqloe4l7AnJuKrdXSe6Y1XY3BXMy0=";
      "0.22.4" = "sha256-61TeK4GsfMLmjYGn3ICzkagbc3/Po++Wnqkb2tbJwGA=";
      "0.23.0" = "sha256-m9Pjz7DaGy917M1GjyfqG5Lm5ne7YSlJF2SVcDHe3+0=";
      "0.24.0" = "sha256-Zil0wceeXmq2xy0OVLxa/Ujl4Dtsmc4COyv6Jo7rVaM=";
      "0.24.1" = "sha256-AjQl6YGPgOpQU3sjcaSnZsFJqZV9BYB+iKAE0tX0Qc4=";
      "0.25.1" = "sha256-3I8qMwyjkws2yssmI7s2Dti99uSorNKT29niJBpv0z0=";
    }."${version}";
  };

  odoc-parser_v = odoc-parser.override {
    version = if lib.versionAtLeast version "0.24.0" then
      "2.0.0"
    else if lib.versionAtLeast version "0.20.1" then
      "1.0.1"
    else
      "0.9.0";
  };

  cmdliner_v =
    if lib.versionAtLeast version "0.21.0" then cmdliner_1_1 else cmdliner_1_0;

  library_deps = [
    base
    cmdliner_v
    dune-build-info
    fix
    fpath
    menhirLib
    menhirSdk
    ocp-indent
    stdio
    uuseg
    uutf
  ] ++ lib.optionals (lib.versionAtLeast version "0.20.0") [
    either
    ocaml-version
  ] ++ lib.optionals (lib.versionAtLeast version "0.22.4") [ csexp ]
    ++ (if lib.versionOlder version "0.25.1" then
      [ odoc-parser_v ]
    else [
      camlp-streams
      result
      astring
    ]);
}
