{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, re2
}:

buildPythonPackage rec {
  pname = "fb-re2";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83b2c2cd58d3874e6e3a784cf4cf2f1a57ce1969e50180f92b010eea24ef26cf";
  };

  patches = [
    # Bump stdlib to c++17 to fix build with recent re2
    # https://github.com/facebook/pyre2/issues/24
    # https://github.com/facebook/pyre2/pull/25
    (fetchpatch {
      url = "https://github.com/facebook/pyre2/pull/25/commits/08fb06ec3ccd412ca69483d27234684a04cb91a0.patch";
      hash = "sha256-kzxE2AxpE1tJJK0dJgoFfVka9zy2u0HEqiHoS7DQDQ0=";
    })
  ];

  buildInputs = [ re2 ];

  # no tests in PyPI tarball
  doCheck = false;

  meta = {
    description = "Python wrapper for Google's RE2";
    homepage = "https://github.com/facebook/pyre2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
