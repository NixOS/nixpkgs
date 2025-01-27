{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  qcheck,
}:

buildDunePackage rec {
  pname = "stdint";
  version = "0.7.2";

  duneVersion = "3";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/andrenth/ocaml-stdint/releases/download/${version}/stdint-${version}.tbz";
    sha256 = "sha256-FWAZjYvJx68+qVLEDavoJmZpQhDsw/35u/60MhHpd+Y=";
  };

  # 1. disable remaining broken tests, see
  #    https://github.com/andrenth/ocaml-stdint/issues/59
  # 2. fix tests to liberal test range
  #    https://github.com/andrenth/ocaml-stdint/pull/61
  postPatch = ''
    substituteInPlace tests/stdint_test.ml \
      --replace 'test "An integer should perform left-shifts correctly"' \
                'skip "An integer should perform left-shifts correctly"' \
      --replace 'test "Logical shifts must not sign-extend"' \
                'skip "Logical shifts must not sign-extend"'
  '';

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ qcheck ];

  meta = {
    description = "Various signed and unsigned integers for OCaml";
    homepage = "https://github.com/andrenth/ocaml-stdint";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gebner ];
  };
}
