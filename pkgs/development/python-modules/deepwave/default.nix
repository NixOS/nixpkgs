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
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ar4";
    repo = "deepwave";
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

  # The source files are compiled at runtime and cached at the
  # $HOME/.cache folder, so for the check phase it is needed to
  # have a temporary home. This is also the reason ninja is not
  # needed at the nativeBuildInputs, since it will only be used
  # at runtime.
  preBuild = ''
    export HOME=$(mktemp -d)
  '';

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

  meta = {
    description = "Wave propagation modules for PyTorch";
    homepage = "https://github.com/ar4/deepwave";
    license = lib.licenses.mit;
    platforms = lib.intersectLists lib.platforms.x86_64 lib.platforms.linux;
    maintainers = with lib.maintainers; [ atila ];
  };
}
