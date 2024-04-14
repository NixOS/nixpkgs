{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
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
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "d8c45c259d62955004379592e45bc64c8e002fc3";
    hash = "sha256-kS48aHC719wUdc2WcJa9geoMUcLHSj7ZsoRZYAhF2a0=";
  };

  patches = [
    # https://github.com/scikit-fuzzy/scikit-fuzzy/pull/299
    (fetchpatch {
      name = "numpy-1.25-test-compatibility-1.patch";
      url = "https://github.com/scikit-fuzzy/scikit-fuzzy/commit/d7d114cff002e2edf9361a55cb985615e91797b5.patch";
      hash = "sha256-udF/z94tVGRHq7gcOko4BSkvVnqe/A/bAARfCPrc06M=";
    })
    (fetchpatch {
      name = "numpy-1.25-test-compatibility-2.patch";
      url = "https://github.com/scikit-fuzzy/scikit-fuzzy/commit/f1612f6aeff34dc9329dbded7cee098fcd22ffd9.patch";
      hash = "sha256-Le1ECR4+RjWCkfqjVrd471GD7tuVaQlZ7RZd3zvFdHU=";
    })
    (fetchpatch {
      name = "numpy-1.25-test-compatibility-3.patch";
      url = "https://github.com/scikit-fuzzy/scikit-fuzzy/commit/459b9602cf182b7b42f93aad8bcf3bda6f20bfb5.patch";
      hash = "sha256-gKrhNpGt6XoAlMwQW70OPFZj/ZC8NhQq6dEaBpGE8yY=";
    })
  ];

  propagatedBuildInputs = [ networkx numpy scipy ];
  nativeCheckInputs = [ matplotlib nose pytestCheckHook ];

  pytestFlagsArray = [
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
  ];

  pythonImportsCheck = [ "skfuzzy" ];

  meta = with lib; {
    homepage = "https://github.com/scikit-fuzzy/scikit-fuzzy";
    description = "Fuzzy logic toolkit for scientific Python";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
