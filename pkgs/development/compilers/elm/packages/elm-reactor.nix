{ mkDerivation, aeson, base, blaze-html, blaze-markup, bytestring
, cmdargs, containers, directory, elm-compiler, elm-package
, fetchgit, file-embed, filepath, fsnotify, mtl, process, snap-core
, snap-server, stdenv, template-haskell, text, time, transformers
, unordered-containers, utf8-string, websockets, websockets-snap
}:
mkDerivation {
  pname = "elm-reactor";
  version = "0.18";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-reactor";
    sha256 = "0lpidsckyfcr8d6bln735d98dx7ga7j1vyssw0qsv8ijj18gxx65";
    rev = "c519d4ec0aaf2f043a416fe858346b0181eca516";
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
  homepage = http://elm-lang.org;
  description = "Interactive development tool for Elm programs";
  license = stdenv.lib.licenses.bsd3;
}
