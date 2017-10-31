{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}:
build-idris-package {
  name = "wl-pprint-2016-09-28";

  src = fetchFromGitHub {
    owner = "shayan-najd";
    repo = "wl-pprint";
    rev = "4cc88a0865620a3b997863e4167d3b98e1a41b52";
    sha256 = "1yxxh366k5njad75r0xci2q5c554cddvzgrwk43b0xn8rq0vm11x";
  };

  # The tests for this package fail. We should attempt to enable them when
  # updating this package again.
  doCheck = false;

  propagatedBuildInputs = [ prelude base ];

  meta = {
    description = "Wadler-Leijen pretty-printing library";
    homepage = https://github.com/shayan-najd/wl-pprint;
    license = lib.licenses.bsd2;
    inherit (idris.meta) platforms;
  };
}
