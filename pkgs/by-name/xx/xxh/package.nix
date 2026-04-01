{
  lib,
  fetchFromGitHub,
  python3,
  openssh,
  nixosTests,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "xxh";
  version = "0.8.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xxh";
    repo = "xxh";
    tag = finalAttrs.version;
    hash = "sha256-Y1yTn0lZemQgWsW9wlW+aNndyTXGo46PCbCl0TGYspQ=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = [
    openssh
  ]
  ++ (with python3.pkgs; [
    pexpect
    pyyaml
  ]);

  passthru.tests = {
    inherit (nixosTests) xxh;
  };

  meta = {
    description = "Bring your favorite shell wherever you go through SSH";
    homepage = "https://github.com/xxh/xxh";
    changelog = "https://github.com/xxh/xxh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pasqui23 ];
  };
})
