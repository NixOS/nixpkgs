{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, docopt
, hidapi
, pyusb
, smbus-cffi
}:

buildPythonPackage rec {
  pname = "liquidctl";
  version = "1.4.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1h5kqpvlx7xppd2wli986lkslqkcrlz1wixv7fvrppzjc2nfz5d4";
  };

  propagatedBuildInputs = [
    docopt
    hidapi
    pyusb
    smbus-cffi
  ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "liquidctl" ];

  meta = with lib; {
    description = "Cross-platform CLI and Python drivers for AIO liquid coolers and other devices";
    homepage    = "https://github.com/liquidctl/liquidctl";
    changelog   = "https://github.com/liquidctl/liquidctl/blob/master/CHANGELOG.md";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ arturcygan ];
  };
}
