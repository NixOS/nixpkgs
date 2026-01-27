{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  version ?
    # The 2.1.0 release is compatible with OCaml >= 4.08. To avoid breaking packages, the requirement is set to the latest release.
    # In general, it's better to specify versions explicitly to avoid breaking packages, ie. use ocamlPackages.cmdliner_X_X.
    if lib.versionAtLeast ocaml.version "5.4.0" then
      "2.1.0"
    else if lib.versionAtLeast ocaml.version "4.08" then
      "1.3.0"
    else if lib.versionAtLeast ocaml.version "4.03" then
      "1.0.4"
    else
      null,
}:

let
  release = {
    "2.1.0" = {
      sha256 = "1s9lhkzrblaf1rk0b9lg95622p0jv4qmmby8xg8jzma3rlacc548";
      minimalOCamlVersion = "4.08";
    };
    "1.3.0" = {
      sha256 = "1fwc2rj6xfyihhkx4cn7zs227a74rardl262m2kzch5lfgsq10cf";
      minimalOCamlVersion = "4.08";
    };
    "1.0.4" = {
      sha256 = "1h04q0zkasd0mw64ggh4y58lgzkhg6yhzy60lab8k8zq9ba96ajw";
      minimalOCamlVersion = "4.03";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "cmdliner";
  src = fetchurl {
    inherit (release.${finalAttrs.version}) sha256;
    url = "https://erratique.ch/software/cmdliner/releases/cmdliner-${finalAttrs.version}.tbz";
  };

  nativeBuildInputs = [ ocaml ];

  makeFlags = [ "PREFIX=$(out)" ];
  installTargets = "install install-doc";
  installFlags = [
    "LIBDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib/cmdliner"
    "DOCDIR=$(out)/share/doc/cmdliner"
  ];
  postInstall = ''
    mv $out/lib/ocaml/${ocaml.version}/site-lib/cmdliner/{opam,cmdliner.opam}
  '';

  meta = {
    homepage = "https://erratique.ch/software/cmdliner";
    description = "OCaml module for the declarative definition of command line interfaces";
    license = lib.licenses.isc;
    inherit (ocaml.meta) platforms;
    maintainers = with lib.maintainers; [ vbgl ];
    broken = !(lib.versionAtLeast ocaml.version release.${finalAttrs.version}.minimalOCamlVersion);
  };
})
