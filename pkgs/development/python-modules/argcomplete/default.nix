{ buildPythonPackage, fetchPypi, lib,
  dicttoxml, pexpect, prettytable, requests_toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06c8a54ffaa6bfc9006314498742ec8843601206a3b94212f82657673662ecf1";
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
