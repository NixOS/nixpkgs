{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "argcomplete";
  version = "3.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kislyuk";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-N1Us/dpF/y638qIuwTzBiuv4vXfBMtWxmQnMBxNTUuc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  # Tries to build and install test packages which fails
  doCheck = false;

  pythonImportsCheck = [
    "argcomplete"
  ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    changelog = "https://github.com/kislyuk/argcomplete/blob/v${version}/Changes.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ womfoo ];
  };
}
