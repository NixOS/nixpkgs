{ mkDerivation, aeson, base, blaze-html, blaze-markup, bytestring
, cmdargs, containers, directory, elm-compiler, elm-package
, fetchgit, file-embed, filepath, fsnotify, mtl, process, snap-core
, snap-server, stdenv, template-haskell, text, time, transformers
, unordered-containers, utf8-string, websockets, websockets-snap
}:
mkDerivation {
  pname = "elm-reactor";
  version = "0.17.1";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-reactor";
    sha256 = "14kkqskvhkfznpl8cmjlvv3rp6ciqmdbxrmq6f20p3aznvkrdvf8";
    rev = "7522d7ef379c5a4ffbba11b1be09ed04add08a63";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base blaze-html blaze-markup bytestring cmdargs containers
    directory elm-compiler elm-package file-embed filepath fsnotify mtl
    process snap-core snap-server template-haskell text time
    transformers unordered-containers utf8-string websockets
    websockets-snap
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "Interactive development tool for Elm programs";
  license = stdenv.lib.licenses.bsd3;
}
