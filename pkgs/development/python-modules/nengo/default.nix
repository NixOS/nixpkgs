{ lib, fetchFromGitHub, buildPythonPackage
, numpy
, scipySupport ? false, scipy
, scikitSupport ? false, scikit-learn
}:

buildPythonPackage rec {
  pname = "nengo";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo";
    rev = "v${version}";
    sha256 = "12lz8lzirxvwnpa74k9k48c64gs6gi092928rh97siya3i6gjs6i";
  };

  propagatedBuildInputs = [ numpy ]
    ++ lib.optionals scipySupport [ scipy ]
    ++ lib.optionals scikitSupport [ scikit-learn ];

  # checks req missing:
  #   pytest-allclose
  #   pytest-plt
  #   pytest-rng
  doCheck = false;

  pythonImportsCheck = [ "nengo" ];

  meta = with lib; {
    description = "A Python library for creating and simulating large-scale brain models";
    homepage    = "https://nengo.ai/";
    license     = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ arjix ];
  };
}
