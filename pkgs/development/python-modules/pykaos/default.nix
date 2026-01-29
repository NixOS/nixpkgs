{
  lib,
  buildPythonPackage,
  kimi-cli,
  uv-build,
  aiofiles,
  asyncssh,
}:

let
  inherit (kimi-cli) version src;
in
buildPythonPackage {
  pname = "kaos";
  inherit version;
  src = src + /packages/kaos;
  pyproject = true;

  # Remove this phase
  # after the PR https://github.com/MoonshotAI/kimi-cli/pull/743/ is merged and released.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.5,<0.9.0" "uv_build>=0.8.5,<0.10.0"
  '';

  build-system = [ uv-build ];
  pythonRelaxDeps = true;

  dependencies = [
    aiofiles
    asyncssh
  ];

  meta = {
    description = "A lightweight Python library providing an abstraction layer for agents to interact with operating systems";
    homepage = "https://github.com/MoonshotAI/kimi-cli/tree/main/packages/kaos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
  };
}
