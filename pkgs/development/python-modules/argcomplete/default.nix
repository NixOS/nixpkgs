{ buildPythonPackage, fetchPypi, lib,
  coverage, dicttoxml, flake8, pexpect, prettytable, requests_toolbelt
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "argcomplete";
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d97b7f3cfaa4e494ad59ed6d04c938fc5ed69b590bd8f53274e258fb1119bd1b";
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
