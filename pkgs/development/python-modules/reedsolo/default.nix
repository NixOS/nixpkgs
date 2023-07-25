{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, cython
, nose
}:

buildPythonPackage rec {
  pname = "reedsolo";
  version = "1.5.4";

  # Pypi does not have the tests
  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "reedsolomon";
    rev = "v${version}";
    hash = "sha256-GUMdL5HclXxqMYasq9kUE7fCqOkjr1D20wjd/E+xPBk=";
  };

  patches = [
    (fetchpatch {
      # python3.10 compat; https://github.com/tomerfiliba/reedsolomon/pull/38
      url = "https://github.com/tomerfiliba/reedsolomon/commit/63e5bd9fc3ca503990c212eb2c77c10589e6d6c3.patch";
      hash = "sha256-47g+jUsJEAyqGnlzRA1oSyc2XFPUOfH0EW+vcOJzsxI=";
    })
  ];

  nativeBuildInputs = [ cython ];

  nativeCheckInputs = [ nose ];
  checkPhase = "nosetests";

  meta = with lib; {
    description = "Pure-python universal errors-and-erasures Reed-Solomon Codec";
    homepage = "https://github.com/tomerfiliba/reedsolomon";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ yorickvp ];
  };
}
