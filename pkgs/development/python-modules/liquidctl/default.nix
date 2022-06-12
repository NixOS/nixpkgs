{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, installShellFiles
, docopt
, hidapi
, pyusb
, smbus-cffi
, i2c-tools
, pytestCheckHook
, colorlog
}:

buildPythonPackage rec {
  pname = "liquidctl";
  version = "1.8.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0cl1xg3rqpn4yjflwcz667pwfjnbq0g41pkg2nak7x9mxqnbdk70";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    docopt
    hidapi
    pyusb
    smbus-cffi
    i2c-tools
    colorlog
  ];

  propagatedNativeBuildInputs = [
    smbus-cffi
  ];

  outputs = [ "out" "man" ];

  postInstall = ''
    installManPage liquidctl.8
    installShellCompletion extra/completions/liquidctl.bash

    mkdir -p $out/lib/udev/rules.d
    cp extra/linux/71-liquidctl.rules $out/lib/udev/rules.d/.
  '';

  checkInputs = [ pytestCheckHook ];

  postBuild = ''
    # needed for pythonImportsCheck
    export XDG_RUNTIME_DIR=$TMPDIR
  '';

  pythonImportsCheck = [ "liquidctl" ];

  meta = with lib; {
    description = "Cross-platform CLI and Python drivers for AIO liquid coolers and other devices";
    homepage = "https://github.com/liquidctl/liquidctl";
    changelog = "https://github.com/liquidctl/liquidctl/blob/master/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ arturcygan evils ];
  };
}
