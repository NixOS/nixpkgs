{ build-idris-package
, fetchFromGitHub
, prelude
, lib
, idris
}:

build-idris-package  {
  name = "bytes";
  version = "2018-02-10";

  idrisDeps = [ prelude ];

  extraBuildInputs = [ idris ];

  src = fetchFromGitHub {
    owner = "ziman";
    repo = "idris-bytes";
    rev = "c0ed9db526d4529780f9d7d2636a40faa07661a5";
    sha256 = "1xyb7k0mrk5imjf5jr2gvqwvasbfy6j4lxvz99r9icfz7crz8dfp";
  };

  meta = {
    description = "FFI-based byte buffers for Idris";
    homepage = https://github.com/ziman/idris-bytes;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
