{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, jheiling-extras
, jheiling-js
, lib
, idris
}:

build-idris-package  {
  name = "electron";
  version = "2016-03-07";

  idrisDeps = [ prelude contrib jheiling-extras jheiling-js ];

  src = fetchFromGitHub {
    owner = "jheiling";
    repo = "idris-electron";
    rev = "f0e86f52b8e5a546a2bf714709b659c1c0b04395";
    sha256 = "1rpa7yjvfpzl06h0qbk54jd2n52nmgpf7nq5aamcinqh7h5gbiwn";
  };

  postUnpack = ''
    rm source/example_main.ipkg
    rm source/example_view.ipkg
  '';

  meta = {
    description = "Electron bindings for Idris";
    homepage = https://github.com/jheiling/idris-electron;
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
