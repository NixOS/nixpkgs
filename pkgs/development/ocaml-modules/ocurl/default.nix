{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  ocaml,
  findlib,
  curl,
  lwt,
  lwt_ppx,
}:
if lib.versionOlder ocaml.version "4.04" then
  throw "ocurl is not available for OCaml ${ocaml.version}"
else
  stdenv.mkDerivation rec {
    pname = "ocurl";
    version = "0.9.2";

    src = fetchurl {
      url = "https://github.com/ygrek/ocurl/releases/download/${version}/ocurl-${version}.tar.gz";
      sha256 = "sha256-4DWXGMh02s1VwLWW5d7h0jtMOUubWmBPGm1hghfWd2M=";
    };

    nativeBuildInputs = [
      pkg-config
      ocaml
      findlib
    ];
    propagatedBuildInputs = [
      curl
      lwt
      lwt_ppx
    ];

    strictDeps = true;

    createFindlibDestdir = true;
    meta = {
      description = "OCaml bindings to libcurl";
      license = lib.licenses.mit;
      homepage = "http://ygrek.org.ua/p/ocurl/";
      maintainers = with lib.maintainers; [
        dandellion
        bennofs
      ];
      platforms = ocaml.meta.platforms or [ ];
    };
  }
