{ buildPythonPackage, fetchPypi, lib
, dicttoxml
, importlib-metadata
, pexpect
, prettytable
, requests_toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "849c2444c35bb2175aea74100ca5f644c29bf716429399c0f2203bb5d9a8e4e6";
  };

  doCheck = false; # meant to be ran with interactive interpreter

  # re-enable if we are able to make testing work
  # checkInputs = [ bashInteractive coverage flake8 ];

  propagatedBuildInputs = [
    dicttoxml
    importlib-metadata
    pexpect
    prettytable
    requests_toolbelt
  ];

  pythonImportsCheck = [ "argcomplete" ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    maintainers = [ maintainers.womfoo ];
    license = [ licenses.asl20 ];
  };
}
