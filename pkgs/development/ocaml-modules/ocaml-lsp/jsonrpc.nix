{ buildDunePackage
, stdlib-shims
, ppx_yojson_conv_lib
, ocaml-syntax-shims
, yojson
, result
, fetchurl
, lib
, ocaml
, version ?
    if lib.versionAtLeast ocaml.version "4.14" then
      "1.17.0"
    else if lib.versionAtLeast ocaml.version "4.13" then
      "1.10.5"
    else if lib.versionAtLeast ocaml.version "4.12" then
      "1.9.0"
    else
      "1.4.1"
}:

let params = {
  "1.17.0" = {
    name = "lsp";
    minimalOCamlVersion = "4.14";
    sha256 = "sha256-j7i71xfu/SYItNg0WBBbZg4N46ETTcj8IWrmWdTRlgA=";
  };
  "1.14.2" = {
    name = "lsp";
    minimalOCamlVersion = "4.14";
    sha256 = "sha256-1R+HYaGbPLGDs5DMN3jmnrZFMhMmPUHgF+s+yNzIVJQ=";
  };
  "1.10.5" = {
    name = "jsonrpc";
    minimalOCamlVersion = "4.13";
    sha256 = "sha256-TeJS6t1ruWhWPvWNatrnSUWI6T17XKiosHLYizBDDcw=";
  };
  "1.9.0" = {
    name = "jsonrpc";
    minimalOCamlVersion = "4.12";
    sha256 = "sha256:1ac44n6g3rf84gvhcca545avgf9vpkwkkkm0s8ipshfhp4g4jikh";
  };
  "1.4.1" = {
    name = "jsonrpc";
    minimalOCamlVersion = "4.06";
    sha256 = "1ssyazc0yrdng98cypwa9m3nzfisdzpp7hqnx684rqj8f0g3gs6f";
  };
}."${version}"; in

buildDunePackage rec {
  pname = "jsonrpc";
  inherit version;
  src = fetchurl {
    url = "https://github.com/ocaml/ocaml-lsp/releases/download/${version}/${params.name}-${version}.tbz";
    inherit (params) sha256;
  };

  duneVersion = "3";
  inherit (params) minimalOCamlVersion;

  buildInputs =
    if lib.versionAtLeast version "1.7.0" then
      [ ]
    else
      [ yojson stdlib-shims ocaml-syntax-shims ];

  propagatedBuildInputs =
    if lib.versionAtLeast version "1.7.0" then
      [ ]
    else
      [ ppx_yojson_conv_lib result ];

  meta = with lib; {
    description = "Jsonrpc protocol implementation in OCaml";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
