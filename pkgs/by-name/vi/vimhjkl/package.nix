{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "vimhjkl";
  version = "0.5.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "S-Sigdel";
    repo = "vimhjkl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1Hh6bXuuK3udixgU32yFWkBa9NA3Z7kqI50ynSGCZ+o=";
  };

  build-system = [
    python3Packages.uv-build
  ];

  pythonImportsCheck = [
    "vimhjkl"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11,<0.12" "uv_build"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Learn vim from your terminal with spaced repetition";
    homepage = "https://github.com/S-Sigdel/vimhjkl";
    changelog = "https://github.com/S-Sigdel/vimhjkl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "vimhjkl";
  };
})
