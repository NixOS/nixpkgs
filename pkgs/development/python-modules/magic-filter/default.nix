{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  hatchling,
}:

buildPythonPackage rec {
  pname = "magic-filter";
  version = "1.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "magic-filter";
    tag = "v${version}";
    hash = "sha256-MSYIZ/bzngRu6mG3EGblUotSCA+6bi+l3EymFA8NRZA=";
  };

  postPatch = ''
    substituteInPlace magic_filter/__init__.py \
      --replace '"1"' '"${version}"'
  '';

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "magic_filter" ];

  meta = {
    description = "Magic filter based on dynamic attribute getter";
    homepage = "https://github.com/aiogram/magic-filter";
    changelog = "https://github.com/aiogram/magic-filter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
