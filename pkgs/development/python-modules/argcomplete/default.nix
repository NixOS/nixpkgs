{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "argcomplete";
  version = "3.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kislyuk";
    repo = "argcomplete";
    rev = "refs/tags/v${version}";
    hash = "sha256-um8iFzEHExTRV1BAl86/XKLc7vmf2Ws1dB83agfvoec=";
  };

  patches = [
    # fixes issues with python3Packages.traitlets tests
    # https://git.launchpad.net/ubuntu/+source/python-argcomplete/tree/debian/patches/python-3.13-compat.patch?h=ubuntu/plucky
    # https://github.com/kislyuk/argcomplete/pull/513
    ./python-3.13-compat.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  # Tries to build and install test packages which fails
  doCheck = false;

  pythonImportsCheck = [ "argcomplete" ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    changelog = "https://github.com/kislyuk/argcomplete/blob/v${version}/Changes.rst";
    downloadPage = "https://github.com/kislyuk/argcomplete";
    license = licenses.asl20;
    maintainers = with maintainers; [ womfoo ];
  };
}
