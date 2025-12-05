{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  pkg-config,
  gmp,
  version ? if lib.versionAtLeast ocaml.version "4.08" then "1.14" else "1.13",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-zarith";
  inherit version;
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "Zarith";
    rev = "release-${version}";
    hash =
      {
        "1.13" = "sha256-CNVKoJeO3fsmWaV/dwnUA8lgI4ZlxR/LKCXpCXUrpSg=";
        "1.14" = "sha256-xUrBDr+M8uW2KOy7DZieO/vDgsSOnyBnpOzQDlXJ0oE=";
      }
      ."${finalAttrs.version}";
  };

  nativeBuildInputs = [
    pkg-config
    ocaml
    findlib
  ];
  propagatedBuildInputs = [ gmp ];
  strictDeps = true;

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];
  configureFlags = [ "-installdir ${placeholder "out"}/lib/ocaml/${ocaml.version}/site-lib" ];

  preInstall = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs";

  meta = with lib; {
    description = "Fast, arbitrary precision OCaml integers";
    homepage = "https://github.com/ocaml/Zarith";
    changelog = "https://github.com/ocaml/Zarith/raw/${finalAttrs.src.rev}/Changes";
    license = licenses.lgpl2;
    inherit (ocaml.meta) platforms;
    maintainers = with maintainers; [
      thoughtpolice
      vbgl
    ];
    broken = lib.versionOlder ocaml.version "4.04";
  };
})
