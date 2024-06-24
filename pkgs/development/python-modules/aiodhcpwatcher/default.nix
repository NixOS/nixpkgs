{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  scapy,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiodhcpwatcher";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodhcpwatcher";
    rev = "v${version}";
    hash = "sha256-0of+no92s9SEKG1tc9lFlWR8f5Jnf3C723goQViB6+A=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [ scapy ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiodhcpwatcher" ];

  meta = with lib; {
    description = "Watch for DHCP packets with asyncio";
    homepage = "https://github.com/bdraco/aiodhcpwatcher";
    changelog = "https://github.com/bdraco/aiodhcpwatcher/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
