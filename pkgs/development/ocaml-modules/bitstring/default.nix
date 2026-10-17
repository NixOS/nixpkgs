{
  lib,
  fetchFromGitHub,
  ocaml,
  buildDunePackage,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "bitstring";
  version = if lib.versionAtLeast ocaml.version "5.3" then "5.0.2" else "4.1.1";

  src = fetchFromGitHub {
    owner = "xguerin";
    repo = "bitstring";
    tag = "v${finalAttrs.version}";
    hash =
      {
        "5.0.2" = "sha256-MN16b37EM5NIZcvd59Y9Bd+YgcM62RdhrgCskd21tSg=";
        "4.1.1" = "sha256-eO7/S9PoMybZPnQQ+q9qbqKpYO4Foc9OjW4uiwwNds8=";
      }
      ."${finalAttrs.version}";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = "https://github.com/xguerin/bitstring";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.maurer ];
  };
})
