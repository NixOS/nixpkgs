{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  ounit,
  ounit2,
  seq,
}:

let
  version_sha =
    if lib.versionAtLeast ocaml.version "4.12" then
      {
        version = "1.12.0";
        hash = "sha256-oB8r8i9ywvSrq9jT52NeNcG/a8WkGtbVoAdFTdq60dQ=";
      }
    else if lib.versionAtLeast ocaml.version "4.08" then
      {
        version = "1.11.0";
        hash = "sha256-AfwkR4DA9r5yrnlrH7dQ82feGGJP110H7nl4LtbfjU8=";
      }
    else
      {
        version = "1.9.0";
        hash = "sha256:1gas4ky49zgxph3870nffzkr6y41kkpqp4nj38pz1gh49zcf12aj";
      };
in

buildDunePackage rec {
  pname = "re";
  version = version_sha.version;

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ocaml/ocaml-re/releases/download/${version}/re-${version}.tbz";
    inherit (version_sha) hash;
  };

  propagatedBuildInputs = [ seq ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ (if lib.versionAtLeast version "1.12" then ounit2 else ounit) ];

  meta = {
    homepage = "https://github.com/ocaml/ocaml-re";
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
