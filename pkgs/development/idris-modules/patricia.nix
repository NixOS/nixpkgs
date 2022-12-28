{ build-idris-package
, fetchFromGitHub
, specdris
, lib
}:
build-idris-package  {
  pname = "patricia";
  version = "2017-10-27";

  idrisDeps = [ specdris ];

  src = fetchFromGitHub {
    owner = "ChShersh";
    repo = "idris-patricia";
    rev = "24724e6d0564f2f813d0d0a58f5c5db9afe35313";
    sha256 = "093q3qjmr93wv8pqwk0zfm3hzf14c235k9c9ip53rhg6yzcm0yqz";
  };

  meta = {
    description = "Immutable map from integer keys to values based on patricia tree. Basically persistent array.";
    homepage = "https://github.com/ChShersh/idris-patricia";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
