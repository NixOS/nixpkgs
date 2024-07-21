{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "zigpy-cli";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-OxVSEBo+wFEBZnWpmQ4aUZWppCh0oavxlQvwDXiWiG8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bellows
    click
    coloredlogs
    scapy
    zigpy
    zigpy-deconz
    zigpy-xbee
    # zigpy-zboss # not packaged
    zigpy-zigate
    zigpy-znp
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zigpy_cli"
  ];

  meta = with lib; {
    description = "Command line interface for zigpy";
    mainProgram = "zigpy";
    homepage = "https://github.com/zigpy/zigpy-cli";
    changelog = "https://github.com/zigpy/zigpy/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.linux;
  };
}
