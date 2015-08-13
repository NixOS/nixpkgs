{ mkDerivation, base, blaze-html, blaze-markup, bytestring, cmdargs
, containers, directory, elm-compiler, fetchgit, filepath, fsnotify
, HTTP, mtl, process, snap-core, snap-server, stdenv
, system-filepath, text, time, transformers, unordered-containers
, websockets, websockets-snap
}:
mkDerivation {
  pname = "elm-reactor";
  version = "0.3.2";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-reactor";
    sha256 = "a7775971ea6634f13436f10098c462d39c6e115dbda79e537831a71975451e9a";
    rev = "b6c11be539734e72015ce151a9189d06dfc9db76";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    base blaze-html blaze-markup bytestring cmdargs containers
    directory elm-compiler filepath fsnotify HTTP mtl process snap-core
    snap-server system-filepath text time transformers
    unordered-containers websockets websockets-snap
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "Interactive development tool for Elm programs";
  license = stdenv.lib.licenses.bsd3;
}
