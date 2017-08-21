{ buildPythonPackage, fetchPypi, lib,
  coverage, dicttoxml, flake8, pexpect, prettytable, requests_toolbelt
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "argcomplete";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sslhl1klvh92c8hjsz3y3mmnpcqspcgi49g5cik2rpbfkhcsb3s";
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
