{ lib, buildPythonPackage, fetchFromGitHub, cython, nose }:

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

  nativeBuildInputs = [ cython ];

  checkInputs = [ nose ];
  checkPhase = "nosetests";

  meta = with lib; {
    description = "Pure-python universal errors-and-erasures Reed-Solomon Codec";
    homepage = "https://github.com/tomerfiliba/reedsolomon";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ yorickvp ];
  };
}
