{ build-idris-package
, fetchFromGitHub
, prelude
, specdris
, lib
, idris
}:
build-idris-package  {
  name = "patricia";
  version = "2017-10-27";

  idrisDeps = [ prelude specdris ];

  src = fetchFromGitHub {
    owner = "ChShersh";
    repo = "idris-patricia";
    rev = "24724e6d0564f2f813d0d0a58f5c5db9afe35313";
    sha256 = "093q3qjmr93wv8pqwk0zfm3hzf14c235k9c9ip53rhg6yzcm0yqz";
  };

  postUnpack = ''
    rm source/patricia-nix.ipkg
  '';

  meta = {
    description = "Immutable map from integer keys to values based on patricia tree. Basically persistent array.";
    homepage = https://github.com/ChShersh/idris-patricia;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
