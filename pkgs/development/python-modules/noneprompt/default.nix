{
  buildPythonPackage,
  fetchPypi,
  lib,
  uv-build,
  prompt-toolkit,
}:

buildPythonPackage rec {
  pname = "noneprompt";
  version = "0.1.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aCJpGPKhVDqjgMqtpcOArlyjj1cpInjFv9O3KJ8axts=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build >=0.8.3, <0.9.0" uv_build
  '';

  build-system = [ uv-build ];

  dependencies = [ prompt-toolkit ];

  # no test
  doCheck = false;

  pythonImportsCheck = [ "noneprompt" ];

  meta = {
    description = "Prompt toolkit for console interaction";
    homepage = "https://github.com/nonebot/noneprompt";
    changelog = "https://github.com/nonebot/noneprompt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "noneprompt";
  };
}
