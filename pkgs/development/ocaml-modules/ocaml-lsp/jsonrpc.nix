{ buildDunePackage
, stdlib-shims
, ppx_yojson_conv_lib
, ocaml-syntax-shims
, yojson
, result
, fetchurl
, lib
, ocaml
<<<<<<< HEAD
, version ?
    if lib.versionAtLeast ocaml.version "4.14" then
      "1.16.2"
    else if lib.versionAtLeast ocaml.version "4.13" then
      "1.10.5"
    else if lib.versionAtLeast ocaml.version "4.12" then
      "1.9.0"
    else
      "1.4.1"
}:

let params = {
  "1.16.2" = {
    name = "lsp";
    minimalOCamlVersion = "4.14";
    sha256 = "sha256-FIfVpOLy1PAjNBBYVRvbi6hsIzZ7fFtP3aOqfcAqrsQ=";
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
=======
}:

let params =
  if lib.versionAtLeast ocaml.version "4.14"
  then {
    name = "lsp";
    version = "1.14.2";
    sha256 = "sha256-1R+HYaGbPLGDs5DMN3jmnrZFMhMmPUHgF+s+yNzIVJQ=";
  } else if lib.versionAtLeast ocaml.version "4.13"
  then {
    name = "jsonrpc";
    version = "1.10.5";
    sha256 = "sha256-TeJS6t1ruWhWPvWNatrnSUWI6T17XKiosHLYizBDDcw=";
  } else if lib.versionAtLeast ocaml.version "4.12"
  then {
    name = "jsonrpc";
    version = "1.9.0";
    sha256 = "sha256:1ac44n6g3rf84gvhcca545avgf9vpkwkkkm0s8ipshfhp4g4jikh";
  } else {
    name = "jsonrpc";
    version = "1.4.1";
    sha256 = "1ssyazc0yrdng98cypwa9m3nzfisdzpp7hqnx684rqj8f0g3gs6f";
  }
; in

buildDunePackage rec {
  pname = "jsonrpc";
  inherit (params) version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchurl {
    url = "https://github.com/ocaml/ocaml-lsp/releases/download/${version}/${params.name}-${version}.tbz";
    inherit (params) sha256;
  };

  duneVersion = "3";
<<<<<<< HEAD
  inherit (params) minimalOCamlVersion;
=======
  minimalOCamlVersion = "4.06";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    maintainers = with maintainers; [ marsam ];
  };
}
