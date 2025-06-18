{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  cmdliner,
  version ? if lib.versionAtLeast ocaml.version "4.14" then "0.9.10" else "0.9.8",
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "uuidm is not available for OCaml ${ocaml.version}"

  stdenv.mkDerivation
  {
    inherit version;
    pname = "uuidm";
    src = fetchurl {
      url = "https://erratique.ch/software/uuidm/releases/uuidm-${version}.tbz";
      hash =
        {
          "0.9.10" = "sha256-kWVZSofWMyky5nAuxoh1xNhwMKZ2qUahL3Dh27J36Vc=";
          "0.9.8" = "sha256-/GZbkJVDQu1UY8SliK282kUWAVMfOnpQadUlRT/tJrM=";
        }
        ."${version}";
    };

    strictDeps = true;

    nativeBuildInputs = [
      ocaml
      findlib
      ocamlbuild
      topkg
    ];
    configurePlatforms = [ ];
    buildInputs = [
      topkg
      cmdliner
    ];

    inherit (topkg) buildPhase installPhase;

    meta = with lib; {
      description = "OCaml module implementing 128 bits universally unique identifiers version 3, 5 (name based with MD5, SHA-1 hashing) and 4 (random based) according to RFC 4122";
      homepage = "https://erratique.ch/software/uuidm";
      license = licenses.bsd3;
      maintainers = [ maintainers.maurer ];
      mainProgram = "uuidtrip";
      inherit (ocaml.meta) platforms;
    };
  }
