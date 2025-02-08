{
  lib,
  buildPythonPackage,
  fetchPypi,
  matplotlib,
  scikit-image,
  numpy,
  pandas,
  imageio,
  snakeviz,
  pyopengl,
  seaborn,
  torch,
  pythonOlder,
  torchvision,
}:

buildPythonPackage rec {
  pname = "boxx";
  version = "0.10.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-unGnmPksEuqFXHTWJkj9Gv2G/qPDgT6AZXYiG2gtkEA=";
  };

  propagatedBuildInputs = [
    matplotlib
    scikit-image
    numpy
    pandas
    imageio
    snakeviz
    pyopengl
    seaborn
  ];

  nativeCheckInputs = [
    torch
    torchvision
  ];

  pythonImportsCheck = [ "boxx" ];

  # The tests are just a bunch of files with code in them (yikes)
  # intead of normal classes/functions representing test cases.
  # Standard test discovery mechanisms in unittest/pytest complain
  # that no tests were discovered, so we run the files manually.
  checkPhase = ''
    export MPLCONFIGDIR=$(mktemp -d)
    TESTS=$(find test -type f -name '*.py' | sed 's|test/\([^.]*\).py|\1|g')
    touch test/__init__.py
    for test in $TESTS; do
      echo "Running test "$test"..."
      python -m test.$test
    done
  '';

  meta = with lib; {
    description = "Tool-box for efficient build and debug for Scientific Computing and Computer Vision";
    homepage = "https://github.com/DIYer22/boxx";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
