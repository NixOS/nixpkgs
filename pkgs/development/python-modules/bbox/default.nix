{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, matplotlib
, numpy
, pendulum
, pillow
, poetry-core
, pyquaternion
}:

buildPythonPackage rec {
  pname = "bbox";
  version = "0.9.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "varunagrawal";
    repo = pname;
    # matches 0.9.4 on PyPi + tests
    rev = "d3f07ed0e38b6015cf4181e3b3edae6a263f8565";
    hash = "sha256-FrJ8FhlqwmnEB/QvPlkDfqZncNGPhwY9aagM9yv1LGs=";
  };

  nativebuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyquaternion
    numpy
  ];

  nativeCheckInputs = [
    matplotlib
    pendulum
    pillow
    pytestCheckHook
  ];

  disabledTests = [
    # performance test, racy on busy machines
    "test_multi_jaccard_index_2d_performance"
  ];

  pythonImportsCheck = [
    "bbox"
  ];

  meta = with lib; {
    description = "Python library for 2D/3D bounding boxes";
    homepage = "https://github.com/varunagrawal/bbox";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
