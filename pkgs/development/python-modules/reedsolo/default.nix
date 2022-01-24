{ lib, buildPythonPackage, fetchFromGitHub, cython, nose }:

buildPythonPackage rec {
  pname = "reedsolo";
  version = "1.5.4";

  # Pypi does not have the tests
  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "reedsolomon";
    # https://github.com/tomerfiliba/reedsolomon/issues/28
    rev = "73926cdf81b39009bd6e46c8d49f3bbc0eaad4e4";
    sha256 = "03wrr0c32dsl7h9k794b8fwnyzklvmxgriy49mjvvd3val829cc1";
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
