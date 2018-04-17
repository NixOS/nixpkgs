{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}:
build-idris-package  {
  name = "posix";
  version = "2017-11-18";

  idrisDeps = [ prelude base ];

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "idris-posix";
    rev = "1e4787bc4dfcf901f2e1858e5334a6bafa5d27c4";
    sha256 = "14y51vn18v23k56gi3b33rjjwpf02qfb00w8cfy8qycrl8rbgsmb";
  };

  # tests need file permissions
  doCheck = false;

  meta = {
    description = "System POSIX bindings for Idris.";
    homepage = https://github.com/idris-hackers/idris-posix;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
