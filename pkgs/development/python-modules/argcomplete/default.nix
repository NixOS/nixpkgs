{ lib
, buildPythonPackage
, fetchPypi
, pexpect
, pythonOlder
}:

buildPythonPackage rec {
  pname = "argcomplete";
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
