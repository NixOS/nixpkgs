{ mkDerivation, base, blaze-html, blaze-markup, bytestring, cmdargs
, directory, elm-compiler, fetchgit, filepath, fsnotify, mtl
, snap-core, snap-server, stdenv, text, time, transformers
, websockets, websockets-snap
}:
mkDerivation {
  pname = "elm-reactor";
  version = "0.16";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-reactor";
    sha256 = "55605b8443dad20c78e297ce35a603cb107b0c1e57bf1c4710faaebc60396de0";
    rev = "b03166296d11e240fa04cdb748e1f3c4af7afc83";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base blaze-html blaze-markup bytestring cmdargs directory
    elm-compiler filepath fsnotify mtl snap-core snap-server text time
    transformers websockets websockets-snap
  ];
  jailbreak = true;
  homepage = "http://elm-lang.org";
  description = "Interactive development tool for Elm programs";
  license = stdenv.lib.licenses.bsd3;
}
