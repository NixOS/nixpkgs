{ lib
, python3
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "uchecker";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloudlinux";
    repo = "kcare-uchecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-SST143oi0O9PcJbw4nxHwHNY6HkIGi1WMBzveUYVhJs=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/cloudlinux/kcare-uchecker/pull/52
    (fetchpatch {
      name = "switch-poetry-core.patch";
      url = "https://github.com/cloudlinux/kcare-uchecker/commit/d7d5ab75efa6a355b3dd3190c1edbaba8110c885.patch";
      hash = "sha256-YPPw6M7MGN8nguAvAwjmz0VEYm0RD98ZkoVIq9SP3sA=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "uchecker"
  ];

  meta = with lib; {
    description = "A simple tool to detect outdated shared libraries";
    homepage = "https://github.com/cloudlinux/kcare-uchecker";
    changelog = "https://github.com/cloudlinux/kcare-uchecker/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "uchecker";
  };
}
