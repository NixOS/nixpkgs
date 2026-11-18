{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "aio-ownet";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "aio-ownet";
    tag = "v${version}";
    hash = "sha256-+RIfCtLQu2OBBlj5Lcd7/iiXMuSlvJq3EcXBaXw4T1I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.21,<0.13" "uv_build"
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ uv-build ];

  pythonImportsCheck = [ "aio_ownet" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/hacf-fr/aio-ownet/releases/tag/${src.tag}";
    description = "Asynchronous OWFS (owserver network protocol) client library";
    homepage = "https://github.com/hacf-fr/aio-ownet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
