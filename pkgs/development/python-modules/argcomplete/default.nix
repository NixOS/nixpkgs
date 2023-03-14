{ buildPythonPackage
, fetchPypi
, lib
, pexpect
}:

buildPythonPackage rec {
  pname = "argcomplete";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cuCDQIUtMlREWcDBmq0bSKosOpbejG5XQkVrT1OMpS8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"coverage",' "" \
      --replace " + lint_require" ""
  '';

  # tries to build and install test packages which fails
  doCheck = false;

  propagatedBuildInputs = [
    pexpect
  ];

  pythonImportsCheck = [ "argcomplete" ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    maintainers = [ maintainers.womfoo ];
    license = [ licenses.asl20 ];
  };
}
