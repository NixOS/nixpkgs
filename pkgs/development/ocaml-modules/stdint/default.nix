{ lib, fetchurl, fetchpatch, buildDunePackage, ocaml, qcheck }:

buildDunePackage rec {
  pname = "stdint";
  version = "0.7.0";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/andrenth/ocaml-stdint/releases/download/${version}/stdint-${version}.tbz";
    sha256 = "4fcc66aef58e2b96e7af3bbca9d910aa239e045ba5fb2400aaef67d0041252dc";
  };

  patches = [
    # fix test bug, remove at next release
    (fetchpatch {
      url = "https://github.com/andrenth/ocaml-stdint/commit/fc64293f99f597cdfd4470954da6fb323988e2af.patch";
      sha256 = "0nxck14vfjfzldsf8cdj2jg1cvhnyh37hqnrcxbdkqmpx4rxkbxs";
    })
  ];

  # 1. disable remaining broken tests, see
  #    https://github.com/andrenth/ocaml-stdint/issues/59
  # 2. fix tests to liberal test range
  #    https://github.com/andrenth/ocaml-stdint/pull/61
  postPatch = ''
    substituteInPlace tests/stdint_test.ml \
      --replace 'test "An integer should perform left-shifts correctly"' \
                'skip "An integer should perform left-shifts correctly"' \
      --replace 'test "Logical shifts must not sign-extend"' \
                'skip "Logical shifts must not sign-extend"' \
      --replace 'let pos_int = QCheck.map_same_type abs in_range' \
                'let pos_int = QCheck.int_range 0 maxi'
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
