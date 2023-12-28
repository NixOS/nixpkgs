{ mkDerivation, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, containers, directory, edit-distance, fetchgit
, file-embed, filelock, filepath, ghc-prim, haskeline, HTTP
, http-client, http-client-tls, http-types, language-glsl, lib, mtl
, network, parsec, process, raw-strings-qq, scientific, SHA
, snap-core, snap-server, template-haskell, time
, unordered-containers, utf8-string, vector, zip-archive
}:
mkDerivation {
  pname = "elm";
  # We're building binaries from commit that npm installer is using since
  # November 1st release called 0.19.1-6.
  # These binaries are built with newer ghc version and also support Aarch64 for Linux and Darwin.
  # Upstream git tag for 0.19.1 is still pointing to original commit from 2019.
  version = "0.19.1-6";
  src = fetchgit {
    url = "https://github.com/elm/compiler";
    rev = "2f6dd29258e880dbb7effd57a829a0470d8da48b";
    sha256 = "sha256-6PXucwc9nFN6TxxsSBuwEkKelThtJ6CLshjfsCmHMsE=";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    ansi-terminal ansi-wl-pprint base binary bytestring containers
    directory edit-distance file-embed filelock filepath ghc-prim
    haskeline HTTP http-client http-client-tls http-types language-glsl
    mtl network parsec process raw-strings-qq scientific SHA snap-core
    snap-server template-haskell time unordered-containers utf8-string
    vector zip-archive
  ];
  homepage = "https://elm-lang.org";
  description = "The `elm` command line interface";
  license = lib.licenses.bsd3;
  mainProgram = "elm";
}
