{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, scipySupport ? false, scipy
, scikitSupport ? false, scikit-learn
, pytestCheckHook
, pytest-allclose
, matplotlib
, pytest-plt
, pytest-rng
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

  propagatedBuildInputs = [
    matplotlib
    numpy
  ] ++ lib.optionals scipySupport [ scipy ]
    ++ lib.optionals scikitSupport [ scikit-learn ];

  checkInputs = [
    pytestCheckHook
    pytest-allclose
    pytest-plt
    pytest-rng
  ];

  pythonImportsCheck = [ "nengo" ];

  meta = with lib; {
    description = "A Python library for creating and simulating large-scale brain models";
    homepage    = "https://nengo.ai/";
    license     = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ arjix ];
  };
}
