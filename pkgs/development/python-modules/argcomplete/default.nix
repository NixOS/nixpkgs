{ buildPythonPackage, fetchPypi, lib,
  coverage, dicttoxml, flake8, pexpect, prettytable, requests_toolbelt
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "argcomplete";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6ea272a93bb0387f758def836e73c36fff0c54170258c212de3e84f7db8d5ed";
  };

  doCheck = false; # bash-completion test fails with "compgen: command not found".

  # re-enable if we are able to make testing work
  # buildInputs = [ coverage flake8 ];

  propagatedBuildInputs = [ dicttoxml pexpect prettytable requests_toolbelt ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = https://argcomplete.readthedocs.io;
    maintainers = [ maintainers.womfoo ];
    license = [ licenses.asl20 ];
  };
}
