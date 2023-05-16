{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
=======
, fetchPypi
, pexpect
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "argcomplete";
<<<<<<< HEAD
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
=======
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cuCDQIUtMlREWcDBmq0bSKosOpbejG5XQkVrT1OMpS8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"coverage",' "" \
      --replace " + lint_require" ""
  '';

  propagatedBuildInputs = [
    pexpect
  ];

  # tries to build and install test packages which fails
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
