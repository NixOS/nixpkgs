{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, effects
, libmicrohttpd
, lib
, idris
}:

build-idris-package  {
  name = "mhd";
  version = "2016-04-22";

  idrisDeps = [ prelude contrib effects ];

  extraBuildInputs = [ libmicrohttpd ];

  src = fetchFromGitHub {
    owner = "colin-adams";
    repo = "idris-libmicrohttpd";
    rev = "a8808bc06fa292d4b3389f32cb00716e43122a46";
    sha256 = "0wvp1qi3bn4hk52vsid6acfwvwbs58sggylbpjvkxzycsbhz4nx4";
  };

  meta = {
    description = "A binding of the GNU libmicrohttpd library to the Idris C backend";
    homepage = https://github.com/colin-adams/idris-libmicrohttpd;
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
