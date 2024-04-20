{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "argcomplete";
  version = "3.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kislyuk";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sGXHRHmzapJM/c4D4j3QWhkTNzPNZPLO7JOptnTXuR8=";
  };

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
    changelog = "https://github.com/kislyuk/argcomplete/blob/v${version}/Changes.rst";
    description = "Bash tab completion for argparse";
    downloadPage = "https://github.com/kislyuk/argcomplete";
    homepage = "https://kislyuk.github.io/argcomplete/";
    license = licenses.asl20;
    maintainers = with maintainers; [ womfoo ];
  };
}
