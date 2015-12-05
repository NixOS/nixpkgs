{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}: build-idris-package {
  name = "wl-pprint";

  src = fetchFromGitHub {
    owner = "shayan-najd";
    repo = "wl-pprint";
    rev = "120f654b0b9838b57e10b163d3562d959439fb07";
    sha256 = "1yymdl251zla6hv9rcg06x73gbp6xb0n6f6a02bsy5fqfmrfngcl";
  };

  propagatedBuildInputs = [ prelude base ];

  meta = {
    description = "Wadler-Leijen pretty-printing library";

    homepage = https://github.com/shayan-najd/wl-pprint;

    license = lib.licenses.bsd2;

    inherit (idris.meta) platforms;
  };
}
