{ lib, fetchFromGitHub, buildPythonPackage
, numpy
, scipySupport ? false, scipy
, scikitSupport ? false, scikit-learn
}:

buildPythonPackage rec {
  pname = "nengo";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo";
    rev = "v${version}";
    sha256 = "1wkayimf2jqkbr6piikh5zd6yw8gf2qv4v4bfrprs4laa6wzh2qh";
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
