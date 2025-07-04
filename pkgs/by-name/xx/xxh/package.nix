{
  lib,
  fetchFromGitHub,
  python3,
  openssh,
  nixosTests,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "xxh";
  version = "0.8.14";
  pyproject = true;
  disabled = python3.pkgs.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "xxh";
    repo = "xxh";
    tag = version;
    hash = "sha256-Y1yTn0lZemQgWsW9wlW+aNndyTXGo46PCbCl0TGYspQ=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies = [
    python3.pkgs.pexpect
    python3.pkgs.pyyaml
    openssh
  ];

  passthru.tests = {
    inherit (nixosTests) xxh;
  };

  meta = with lib; {
    description = "Bring your favorite shell wherever you go through SSH";
    homepage = "https://github.com/xxh/xxh";
    license = licenses.bsd2;
    maintainers = with maintainers; [ pasqui23 ];
  };
}
