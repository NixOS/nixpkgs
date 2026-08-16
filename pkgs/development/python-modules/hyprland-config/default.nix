{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  lua5_4,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-config";
  version = "0.9.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jgh/X7M+hdp0NPuA0YnfdYU/sxY9hfl/OCihnzobvm8=";
  };

  # The Lua reader shells out to an interpreter it looks up on PATH at runtime.
  # Hyprland links Lua internally and never installs a `lua` binary, so without
  # this every read of a Lua-mode config raises LuaReaderError.
  postPatch = ''
    substituteInPlace src/hyprland_config/_lua/_read/_runner.py \
      --replace-fail '_LUA_BINARY_CANDIDATES = ("lua", "lua5.5", "lua5.4", "lua5.3", "lua5.2")' \
                     '_LUA_BINARY_CANDIDATES = ("${lib.getExe lua5_4}",)'
  '';

  build-system = [ hatchling ];

  nativeCheckInputs = [
    hypothesis
    lua5_4 # the test helpers probe PATH for lua/luac themselves
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hyprland_config" ];

  meta = {
    description = "Round-trip parser and editor for Hyprland configuration files";
    homepage = "https://github.com/BlueManCZ/hyprland-config";
    changelog = "https://github.com/BlueManCZ/hyprland-config/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
