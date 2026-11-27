{
  lib,
  stdenv,
  fetchFromGitLab,
  ocamlPackages,
  alt-ergo,
  darwin,
  why3,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "why3find";
  version = "1.3.1";

  # why3find looks up its dune-site locations in its library directory at
  # runtime, so the library can't be split into a separate "dev" output.
  outputs = [ "out" ];

  src = fetchFromGitLab {
    domain = "git.frama-c.com";
    owner = "pub";
    repo = "why3find";
    tag = finalAttrs.version;
    hash = "sha256-vDqGp8sznG+QC4T0JpvkGvBY7eIlgfwQTKq/pnGLjDA=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool # codesign
  ];

  buildInputs = with ocamlPackages; [
    cpu
  ];

  propagatedBuildInputs = with ocamlPackages; [
    dune-site
    terminal_size
    why3
    yojson
    xdg
  ];

  doCheck = true;

  nativeCheckInputs = [
    alt-ergo.bin
    why3
  ];

  checkInputs = with ocamlPackages; [
    zmq
  ];

  meta = {
    description = "Why3 Package Manager";
    homepage = "https://git.frama-c.com/pub/why3find";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "why3find";
  };
})
