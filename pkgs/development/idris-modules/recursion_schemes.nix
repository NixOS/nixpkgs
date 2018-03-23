{ build-idris-package
, fetchFromGitHub
, prelude
, free
, composition
, comonad
, bifunctors
, hezarfen
, lib
, idris
}:
build-idris-package  {
  name = "recursion_schemes";
  version = "2018-01-19";

  idrisDeps = [ prelude free composition comonad bifunctors hezarfen ];

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "recursion_schemes";
    rev = "6bcbe0da561f461e7a05e29965a18ec9f87f8d82";
    sha256 = "0rbx0yqa0fb7h7qfsvqvirc5q85z51rcwbivn6351jgn3a0inmhf";
  };

  postUnpack = ''
    rm source/test.ipkg
  '';

  meta = {
    description = "Recursion schemes for Idris";
    homepage = https://github.com/vmchale/recursion_schemes;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
