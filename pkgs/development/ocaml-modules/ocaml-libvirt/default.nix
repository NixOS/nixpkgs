{ lib, stdenv, fetchFromGitLab, libvirt, autoreconfHook, pkg-config, ocaml, findlib, perl }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.02")
  "libvirt is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml-libvirt";
  version = "0.6.1.5";

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-ocaml";
    rev = "v${version}";
    sha256 = "0xpkdmknk74yqxgw8z2w8b7ss8hpx92xnab5fsqg2byyj55gzf2k";
  };

  propagatedBuildInputs = [ libvirt ];

  nativeBuildInputs = [ autoreconfHook pkg-config findlib perl ocaml ];

  strictDeps = true;

  buildFlags = [ "all" "opt" "CPPFLAGS=-Wno-error" ];
  installTargets = "install-opt";
  preInstall = ''
    # Fix 'dllmllibvirt.so' install failure into non-existent directory.
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
  '';

  meta = with lib; {
    description = "OCaml bindings for libvirt";
    homepage = "https://libvirt.org/ocaml/";
    license = licenses.gpl2;
    maintainers = [ ];
    inherit (ocaml.meta) platforms;
  };
}
