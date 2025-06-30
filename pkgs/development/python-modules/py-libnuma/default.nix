{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  numactl,
}:

buildPythonPackage rec {
  pname = "py-libnuma";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eedalong";
    repo = "pynuma";
    rev = "66cab0e008b850a04cfec5c4fb3f50bf28e3d488";
    hash = "sha256-ALYCcdN5eXrVWsTRwkHCwo4xsLMs/du3mUl1xSlo5iU=";
  };

  postPatch = ''
    substituteInPlace numa/__init__.py \
      --replace-fail \
        'LIBNUMA = CDLL(find_library("numa"))' \
        'LIBNUMA = CDLL("${numactl}/lib/libnuma${stdenv.hostPlatform.extensions.sharedLibrary}")'
  '';

  build-system = [ setuptools ];

  dependencies = [
    numactl
  ];

  # Tests write NUMA configuration, which may be persistent until reboot.
  doCheck = false;

  pythonImportsCheck = [ "numa" ];

  meta = {
    description = "Python3 Interface to numa Linux library";
    homepage = "https://github.com/eedalong/pynuma";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
