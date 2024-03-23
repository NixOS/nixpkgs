{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, poetry-core

# dependencies
, scapy

# tests
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiodhcpwatcher";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodhcpwatcher";
    rev = "v${version}";
    hash = "sha256-yvmCp8luR26yFYun/YY/tt+peaAL4nOR9cC6lpMiJhk=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    scapy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiodhcpwatcher"
  ];

  meta = with lib; {
    description = "Watch for DHCP packets with asyncio";
    homepage = "https://github.com/bdraco/aiodhcpwatcher";
    changelog = "https://github.com/bdraco/aiodhcpwatcher/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
