{ build-idris-package
, fetchFromGitHub
, prelude
, base
, effects
, lib
, idris
}: build-idris-package {
  name = "idrisscript";

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "IdrisScript";
    rev = "d0609233956efd296ceb2b2a627c205514216aed";
    sha256 = "1xfhdkiycjhirg6050iv1madwpg2vm4i1in4zx4510djzhvis5kc";
  };

  propagatedBuildInputs = [ prelude base ];

  meta = {
    description = "FFI Bindings to JavaScript";
    homepage = https://github.com/idris-hackers/IdrisScript;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gpyh ];
    inherit (idris.meta) platforms;
  };
}
