{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}:
build-idris-package {
  name = "wl-pprint";
  version = "2017-03-13";

  src = fetchFromGitHub {
    owner = "shayan-najd";
    repo = "wl-pprint";
    rev = "97590d1679b3db07bb430783988b4cba539e9947";
    sha256 = "0ifp76cqg340jkkzanx69vg76qivv53vh1lzv9zkp5f49prkwl5d";
  };

  idrisDeps = [ prelude base ];

  meta = {
    description = "Wadler-Leijen pretty-printing library";
    homepage = https://github.com/shayan-najd/wl-pprint;
    license = lib.licenses.bsd2;
    inherit (idris.meta) platforms;
  };
}
