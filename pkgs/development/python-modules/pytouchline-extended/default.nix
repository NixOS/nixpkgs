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

buildPythonPackage rec {
  pname = "pytouchline-extended";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brondum";
    repo = "pytouchline";
    tag = version;
    hash = "sha256-7F8VeLrMgo54LQWG4BzxL6EgvthssAjUO65HSkXd2sk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '$GITHUB_REF_NAME' '${version}'
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
    changelog = "https://github.com/brondum/pytouchline/releases/tag/${src.tag}";
    description = "Roth Touchline interface library";
    homepage = "https://github.com/brondum/pytouchline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
