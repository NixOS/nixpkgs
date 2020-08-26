{ buildPythonPackage, fetchPypi, lib
, dicttoxml
, importlib-metadata
, pexpect
, prettytable
, requests_toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p19rkvh28klkkd1c6y78h6vb9b9cnlyr7qrshkxghfjkz85xgig";
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
