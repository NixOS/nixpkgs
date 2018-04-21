{ build-idris-package
, fetchFromGitHub
, prelude
, lib
, idris
}:

build-idris-package  {
  name = "idrisscript";
  version = "2017-07-01";

  idrisDeps = [ prelude ];

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "IdrisScript";
    rev = "4bb7019182392f24d2246a3e616f829156c8f091";
    sha256 = "074ignh2hqwq4ng5nk7dswga4lm7342w7h4bmx4n03ygrn7w89ff";
  };

  meta = {
    description = "FFI Bindings to interact with the unsafe world of JavaScript";
    homepage = https://github.com/idris-hackers/IdrisScript;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
