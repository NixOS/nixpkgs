{ build-idris-package
, fetchFromGitHub
, contrib
, effects
, lib
}:
build-idris-package  {
  pname = "wyvern";
  version = "2017-06-26";

  idrisDeps = [ contrib effects ];

  src = fetchFromGitHub {
    owner = "ericqweinstein";
    repo = "wyvern";
    rev = "b9e3e5747c5b23608c6ed5e2ccf43b86caa04292";
    sha256 = "0zihf95w7i0903zy1mzn1ldn697nf57yl80nl32dpgji72h98kh2";
  };

  postUnpack = ''
    sed -i "s/Wyvern.Core/Wyvern.Main/g" source/src/Wyvern.idr
  '';

  meta = {
    description = "Little web server written in Idris";
    homepage = "https://github.com/ericqweinstein/wyvern";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
