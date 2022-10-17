{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, matplotlib
, networkx
, nose
, numpy
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scikit-fuzzy";
  version = "unstable-2021-03-31";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "92ad3c382ac19707086204ac6cdf6e81353345a7";
    sha256 = "0q89p385nsg3lymlsqm3mw6y45vgrk6w9p30igbm59b7r9mkgdj8";
  };

  propagatedBuildInputs = [ networkx numpy scipy ];
  checkInputs = [ matplotlib nose pytestCheckHook ];

  # test error: "ValueError: could not convert string to float: '2.6.2'"
  disabledTestPaths = [ "skfuzzy/control/tests/test_controlsystem.py" ];

  meta = with lib; {
    homepage = "https://github.com/scikit-fuzzy/scikit-fuzzy";
    description = "Fuzzy logic toolkit for scientific Python";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
