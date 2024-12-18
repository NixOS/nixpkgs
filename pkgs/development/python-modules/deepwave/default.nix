{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  torch,
  ninja,
  scipy,
  which,
  pybind11,
  pytest-xdist,
  pytestCheckHook,
  tmpdirAsHomeHook,
}:

let
  linePatch = ''
    import os
    os.environ['PATH'] = os.environ['PATH'] + ':${ninja}/bin'
  '';
in
buildPythonPackage rec {
  pname = "deepwave";
  version = "0.0.18";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ar4";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DOOy+B12jgwJzQ90qzX50OFxYLPRcVdVYSE5gi3pqDM=";
  };

  # unable to find ninja although it is available, most likely because it looks for its pip version
  postPatch = ''
    substituteInPlace setup.cfg --replace "ninja" ""

    # Adding ninja to the path forcibly
    mv src/deepwave/__init__.py tmp
    echo "${linePatch}" > src/deepwave/__init__.py
    cat tmp >> src/deepwave/__init__.py
    rm tmp
  '';

  nativeBuildInputs = [
    tmpdirAsHomeHook
  ];

  propagatedBuildInputs = [
    torch
    pybind11
  ];

  nativeCheckInputs = [
    which
    scipy
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "deepwave" ];

  meta = with lib; {
    description = "Wave propagation modules for PyTorch";
    homepage = "https://github.com/ar4/deepwave";
    license = licenses.mit;
    platforms = intersectLists platforms.x86_64 platforms.linux;
    maintainers = with maintainers; [ atila ];
  };
}
