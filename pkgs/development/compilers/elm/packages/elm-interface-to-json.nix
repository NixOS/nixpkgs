{ mkDerivation, aeson, aeson-pretty, base, binary, bytestring
, concatenative, containers, directory, either, elm-compiler
, filemanip, filepath, indents, optparse-applicative, parsec
, stdenv, text, transformers, fetchgit
}:
mkDerivation {
  pname = "elm-interface-to-json";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/stoeffel/elm-interface-to-json";
    sha256 = "1izc78w91m7nrc9i2b3lgy3kyjsy4d5mkkblx96ws0bp3dpm5f9k";
    rev = "9884c1c997a55f11cf7c3d99a8afa72cf2e97323";
  };
  isLibrary = false;
  isExecutable = true;
  jailbreak = true;
  executableHaskellDepends = [
    aeson aeson-pretty base binary bytestring concatenative containers
    directory either elm-compiler filemanip filepath indents
    optparse-applicative parsec text transformers
  ];
  homepage = "https://github.com/githubuser/elm-interface-to-json#readme";
  license = stdenv.lib.licenses.bsd3;
}
