{ buildPythonPackage, fetchPypi, lib,
  dicttoxml, pexpect, prettytable, requests_toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a37f522cf3b6a34abddfedb61c4546f60023b3799b22d1cd971eacdc0861530a";
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
