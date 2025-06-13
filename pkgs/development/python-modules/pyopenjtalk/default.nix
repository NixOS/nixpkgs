{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,

  cmake,
  cython,
  numpy,
  setuptools,
  setuptools-scm,

  importlib-resources,
  tqdm,

  pytestCheckHook,
  scipy,
}:

let
  dic-dirname = "open_jtalk_dic_utf_8-1.11";
  dic-src = fetchzip {
    name = dic-dirname;
    url = "https://github.com/r9y9/open_jtalk/releases/download/v1.11.1/${dic-dirname}.tar.gz";
    hash = "sha256-+6cHKujNEzmJbpN9Uan6kZKsPdwxRRzT3ZazDnCNi3s=";
  };
in
buildPythonPackage rec {
  pname = "pyopenjtalk";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "r9y9";
    repo = "pyopenjtalk";
    tag = "v${version}";
    hash = "sha256-QUt6Fh0Y/fKyIOCW8leVUqUhBVgM8V91w590PLgq3Ws=";
    fetchSubmodules = true;
  };

  build-system = [
    cmake
    cython
    numpy
    setuptools
    setuptools-scm
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    importlib-resources
    numpy
    tqdm
  ];

  postInstall = ''
    # the package searches for a cached dic directory in this location
    ln -s ${dic-src} $out/${python.sitePackages}/pyopenjtalk/${dic-dirname}
  '';

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  preCheck = ''
    # the built extension modules are only present in $out
    # so we make sure to resolve pyopenjtalk from $out
    rm -r pyopenjtalk
  '';

  pythonImportsCheck = [
    "pyopenjtalk"
  ];

  meta = {
    description = "Python wrapper for OpenJTalk";
    homepage = "https://github.com/r9y9/pyopenjtalk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
