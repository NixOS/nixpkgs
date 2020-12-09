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
  version = "unstable-2020-10-03";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "eecf303b701e3efacdc9b9066207ef605d4facaa";
    sha256 = "18dl0017iqwc7446hqgabhibgjwdakhmycpis6zpvvkkv4ip5062";
  };

  propagatedBuildInputs = [ networkx numpy scipy ];
  checkInputs = [ matplotlib nose pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/scikit-fuzzy/scikit-fuzzy";
    description = "Fuzzy logic toolkit for scientific Python";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
