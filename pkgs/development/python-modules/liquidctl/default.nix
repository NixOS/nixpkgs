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
  version = "1.10.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-2mXWih3LchJ/YsjuwHwWse7SNJYx1vxtovl8vasKV4w=";
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
