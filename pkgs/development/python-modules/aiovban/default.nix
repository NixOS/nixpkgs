{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  music-assistant,
}:

buildPythonPackage {
  pname = "aiovban";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wmbest2";
    repo = "aiovban";
    # https://github.com/wmbest2/aiovban/issues/2
    rev = "cdcf1ef3328493e600b4e8725a6071c0d180b36a";
    hash = "sha256-w+pA3225mdPms/PpnJYKZYe6YHn0WMf83LupExgjJZ8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "aiovban"
  ];

  meta = {
    description = "Asyncio VBAN Protocol Wrapper";
    homepage = "https://github.com/wmbest2/aiovban";
    license = lib.licenses.mit;
    inherit (music-assistant.meta) maintainers;
  };
}
