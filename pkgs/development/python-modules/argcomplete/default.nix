{ buildPythonPackage, fetchPypi, lib,
  dicttoxml, pexpect, prettytable, requests_toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec88b5ccefe2d47d8f14916a006431d0afb756751ee5c46f28654a7d8a69be53";
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
