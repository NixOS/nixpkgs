{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cgroup-utils";
  version = "0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peo3";
    repo = "cgroup-utils";
    rev = "v${version}";
    sha256 = "0qnbn8cnq8m14s8s1hcv25xjd55dyb6yy54l5vc7sby5xzzp11fq";
  };

  postPatch = ''
    sed -i -e "/argparse/d" setup.py
  '';

  build-system = [ setuptools ];

  # Upon running `from cgutils import cgroup`, it attempts to read a file in `/sys`.
  # Due to the Nix build sandbox, this is disallowed, and so all possible tests fail,
  # so we don't run them. Plain `import cgutils` works, so we run pythonImportsCheck below.
  doCheck = false;

  pythonImportsCheck = [ "cgutils" ];

  meta = {
    description = "Utility tools for control groups of Linux";
    homepage = "https://github.com/peo3/cgroup-utils";
    mainProgram = "cgutil";
    maintainers = with lib.maintainers; [ layus ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
