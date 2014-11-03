{ stdenv, fetchurl, ocaml, findlib }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.99.2";
in
stdenv.mkDerivation {
  name = "ppx_tools-${version}";

  src = fetchurl {
    url = "http://github.com/alainfrisch/ppx_tools/archive/ppx_tools_${version}.tar.gz";
    sha256 = "1v2dgjkqkwjdqj6xp6mc9gn0w806prrrpsv3l9lxfx05x8i804lq";
  };

  buildInputs = [ ocaml findlib ];

  preBuild = if ocaml_version != "4.02.1" then ''
    substituteInPlace Makefile --replace "-safe-string" ""
  '' else null;

  createFindlibDestdir = true;
  
  meta = with stdenv.lib;
    { description = "Tools for authors of ppx rewriters and other syntactic tools";
      maintainers = with maintainers; [ emery ];
    };
}
