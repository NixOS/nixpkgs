{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = "msgspec";
    tag = version;
    # Note that this hash changes after some time after release because they
    # use `$Format:%d$` in msgspec/_version.py, and GitHub produces different
    # tarballs depending on whether tagged commit is the last commit, see
    # https://github.com/NixOS/nixpkgs/issues/84312
    hash = "sha256-CajdPNAkssriY/sie5gR+4k31b3Wd7WzqcsFmrlSoPY=";
  };

  build-system = [ setuptools ];

  # Requires libasan to be accessible
  doCheck = false;

  pythonImportsCheck = [ "msgspec" ];

  meta = with lib; {
    description = "Module to handle JSON/MessagePack";
    homepage = "https://github.com/jcrist/msgspec";
    changelog = "https://github.com/jcrist/msgspec/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
