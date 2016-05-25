{ build-idris-package
, fetchFromGitHub
, prelude
, base
, effects
, lib
, idris
}: build-idris-package {
  name = "test";

  src = fetchFromGitHub {
    owner = "jfdm";
    repo = "idris-testing";
    rev = "24a75bb71350fd64b00b72f69daa93530b49e61a";
    sha256 = "1k2qqz9vn9h8g4zxslx61z2g9ks5y29y3fmrlv7vawymkhcjrcl5";
  };

  propagatedBuildInputs = [ prelude base effects ];

  # No suite test
  doCheck = false;

  patchPhase = ''
    rm testparse.ipkg
  '';

  meta = {
    description = "Testing utilities for Idris programs";
    homepage = https://github.com/jfdm/idris-testing;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gpyh ];
    inherit (idris.meta) platforms;
  };
}
