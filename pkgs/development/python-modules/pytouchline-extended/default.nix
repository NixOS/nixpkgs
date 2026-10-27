{
  buildPythonPackage,
  faust-cchardet,
  fetchFromGitHub,
  httpx,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytouchline-extended";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brondum";
    repo = "pytouchline";
    tag = finalAttrs.version;
    hash = "sha256-sIrHvC+IkJWgNksgS5lB4IFP37xggVypMLmGjjLlaVQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '$GITHUB_REF_NAME' '${finalAttrs.version}'
  '';

  build-system = [ setuptools ];

  dependencies = [
    faust-cchardet
    httpx
  ];

  pythonImportsCheck = [ "pytouchline_extended" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/brondum/pytouchline/releases/tag/${finalAttrs.src.tag}";
    description = "Roth Touchline interface library";
    homepage = "https://github.com/brondum/pytouchline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
