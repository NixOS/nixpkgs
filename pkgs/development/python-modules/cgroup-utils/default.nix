{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.8";
  pname = "cgroup-utils";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peo3";
    repo = "cgroup-utils";
    rev = "v${version}";
    hash = "sha256-2IVw/+/FL33YLpQU783yrZQmexGbwaCRJqEibBmyy2I=";
  };

  postPatch = ''
    sed -i -e "/argparse/d" setup.py
    substituteInPlace test_pep8.py --replace-fail \
    'print message' 'print(message)'
    rm test_pep8.py
  '';

  build-system = [ setuptools ];

  # Importing causes it to check the /sys directory, which isn't allowed, and so
  # tests fail. Therefore, tests can't be run.
  doCheck = false;

  pythonImportsCheck = [ "cgutils" ];

  meta = {
    description = "Utility tools for control groups of Linux";
    mainProgram = "cgutil";
    maintainers = with lib.maintainers; [ layus ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
