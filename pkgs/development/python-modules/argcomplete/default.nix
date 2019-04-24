{ buildPythonPackage, fetchPypi, lib,
  dicttoxml, pexpect, prettytable, requests_toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "94423d1a56cdec2ef47699e02c9a48cf8827b9c4465b836c0cefb30afe85e59a";
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
