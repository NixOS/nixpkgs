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
  version = "unstable-2022-11-07";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "d8c45c259d62955004379592e45bc64c8e002fc3";
    hash = "sha256-kS48aHC719wUdc2WcJa9geoMUcLHSj7ZsoRZYAhF2a0=";
  };

  propagatedBuildInputs = [ networkx numpy scipy ];
  nativeCheckInputs = [ matplotlib nose pytestCheckHook ];

  pythonImportsCheck = [ "skfuzzy" ];

  meta = with lib; {
    homepage = "https://github.com/scikit-fuzzy/scikit-fuzzy";
    description = "Fuzzy logic toolkit for scientific Python";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
