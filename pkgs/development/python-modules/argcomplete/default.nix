{ buildPythonPackage, fetchPypi, lib
, dicttoxml
, importlib-metadata
, pexpect
, prettytable
, requests-toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20";
  };

  doCheck = false; # meant to be ran with interactive interpreter

  # re-enable if we are able to make testing work
  # nativeCheckInputs = [ bashInteractive coverage flake8 ];

  propagatedBuildInputs = [
    dicttoxml
    importlib-metadata
    pexpect
    prettytable
    requests-toolbelt
  ];

  pythonImportsCheck = [ "argcomplete" ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    maintainers = [ maintainers.womfoo ];
    license = [ licenses.asl20 ];
  };
}
