{ mkDerivation, base, blaze-html, blaze-markup, bytestring, cmdargs
, directory, elm-compiler, fetchgit, filepath, fsnotify, mtl
, snap-core, snap-server, stdenv, text, time, transformers
, websockets, websockets-snap, elm-package, file-embed
}:
mkDerivation {
  pname = "elm-reactor";
  version = "0.17";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-reactor";
    sha256 = "03lb6fcc5d02gflarxc54l71hbwdb73v423ffjz5hvlha6ixglv7";
    rev = "4781ad2fbb6cbcde0d659dec293bbed9c847ba71";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base blaze-html blaze-markup bytestring cmdargs directory
    elm-compiler filepath fsnotify mtl snap-core snap-server text time
    transformers websockets websockets-snap elm-package file-embed
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "Interactive development tool for Elm programs";
  license = stdenv.lib.licenses.bsd3;
}
