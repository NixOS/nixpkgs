{
  stdenv,
  lib,
  fetchFromGitHub,
  ocaml,
  findlib,
  ocamlbuild,
  opaline,
}:

if lib.versionOlder ocaml.version "4.07" then
  throw "lua-ml is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation rec {
    pname = "lua-ml";
    name = "ocaml${ocaml.version}-${pname}-${version}";
    version = "0.9.2";

    src = fetchFromGitHub {
      owner = "lindig";
      repo = pname;
      rev = version;
      sha256 = "sha256-xkjsjKD89W7Y5XK8kfL/ZErYKS14z0u0QCARN0DbTC8=";
    };

    nativeBuildInputs = [
      opaline
      ocaml
      findlib
      ocamlbuild
    ];

    strictDeps = true;

    buildFlags = [ "lib" ];

    installPhase = ''
      opaline -prefix $out -libdir $OCAMLFIND_DESTDIR
    '';

    meta = {
      description = "An embeddable Lua 2.5 interpreter implemented in OCaml";
      inherit (src.meta) homepage;
      inherit (ocaml.meta) platforms;
      license = lib.licenses.bsd2;
      maintainers = [ lib.maintainers.vbgl ];
    };
  }
