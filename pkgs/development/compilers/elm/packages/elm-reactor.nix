{ mkDerivation, base, blaze-html, blaze-markup, bytestring, cmdargs
, directory, elm-compiler, fetchgit, filepath, fsnotify, mtl, snap-core
, snap-server, stdenv, text, time, transformers, websockets
, websockets-snap
}:
mkDerivation {
  pname = "elm-reactor";
  version = "0.16";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-reactor";
    sha256 = "09jgxprvi8rka609i4hfmdlka9s0ibc1spv7cka741zhiy083y6v";
    rev = "ff4ad13ea6b55c63b2d2099b738fd1d5ec2d29b4";
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
