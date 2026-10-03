{
  lib,
  stdenv,
  fetchFromGitLab,
  libvirt,
  autoreconfHook,
  pkg-config,
  ocaml,
  findlib,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-libvirt";
  version = "0.6.1.5";

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-ocaml";
    rev = "v${version}";
    hash = "sha256-U7j/SpHeL/GwdmUp20XqFyKtz0JcfMRfx56caWdt83Y=";
  };

  propagatedBuildInputs = [ libvirt ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    findlib
    perl
    ocaml
  ];

  strictDeps = true;

  buildFlags = [
    "all"
    "opt"
    "CPPFLAGS=-Wno-error"
  ];
  installTargets = "install-opt";
  preInstall = ''
    # Fix 'dllmllibvirt.so' install failure into non-existent directory.
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
  '';

  meta = {
    description = "OCaml bindings for libvirt";
    homepage = "https://libvirt.org/ocaml/";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    inherit (ocaml.meta) platforms;
    broken = !(lib.versionAtLeast ocaml.version "4.02");
  };
}
