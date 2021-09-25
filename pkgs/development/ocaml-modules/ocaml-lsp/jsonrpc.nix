{ buildDunePackage
, stdlib-shims
, ppx_yojson_conv_lib
, ocaml-syntax-shims
, yojson
, result
, fetchurl
, lib
, ocaml
}:

let params =
  if lib.versionAtLeast ocaml.version "4.12"
  then {
    version = "1.7.0";
    sha256 = "1va2zj41znsr94bdw485vak96zrcvqwcrqf1sy8zipb6hdhbchya";
  } else {
    version = "1.4.1";
    sha256 = "1ssyazc0yrdng98cypwa9m3nzfisdzpp7hqnx684rqj8f0g3gs6f";
  }
; in

buildDunePackage rec {
  pname = "jsonrpc";
  inherit (params) version;
  src = fetchurl {
    url = "https://github.com/ocaml/ocaml-lsp/releases/download/${version}/jsonrpc-${version}.tbz";
    inherit (params) sha256;
  };

  useDune2 = true;
  minimumOCamlVersion = "4.06";

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
    maintainers = with maintainers; [ symphorien marsam ];
  };
}
