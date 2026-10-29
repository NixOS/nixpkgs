{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "osrparse";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kszlim";
    repo = "osu-replay-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MBE4z1SDkr0YA5ommF+WZyR2N67Y1/xmDhxrTrUhQJk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "osrparse" ];

  meta = {
    description = "Parser for osr (osu! replays) file format";
    homepage = "https://github.com/kszlim/osu-replay-parser";
    changelog = "https://github.com/kszlim/osu-replay-parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wulpine ];
  };
})
