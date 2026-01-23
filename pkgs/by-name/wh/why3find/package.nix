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
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "git.frama-c.com";
    owner = "pub";
    repo = "why3find";
    tag = finalAttrs.version;
    hash = "sha256-fqB6VrJ79E6KSAnq8TZGNFlvWbDaBNh+gbuRf0CFFy8=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool # codesign
  ];

  propagatedBuildInputs = with ocamlPackages; [
    dune-site
    terminal_size
    why3
    yojson
    zmq
  ];

  doCheck = true;

  nativeCheckInputs = [
    alt-ergo.bin
    why3
  ];

  meta = {
    description = "Why3 Package Manager";
    homepage = "https://git.frama-c.com/pub/why3find";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "why3find";
  };
})
