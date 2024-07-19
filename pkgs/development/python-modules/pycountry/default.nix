{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch2,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "23.12.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pycountry";
    repo = "pycountry";
    rev = "refs/tags/${version}";
    hash = "sha256-B6kphZZZgK0YuPSmkiQNbEqEfqOQb+WZGnO2UeEqQN4=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-usage-of-importlib_metadata.patch";
      url = "https://github.com/pycountry/pycountry/commit/824d2535833d061c04a1f1b6b964f42bb53bced2.patch";
      excludes = [
        "HISTORY.txt"
        "poetry.lock"
        "pyproject.toml"
      ];
      hash = "sha256-U4fbZP++d6YfTJkVG3k2rBC8nOF9NflM6+ONlwBNu+g=";
    })
  ];

  postPatch = ''
    sed -i "/addopts/d" pytest.ini
  '';

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycountry" ];

  meta = {
    homepage = "https://github.com/pycountry/pycountry";
    changelog = "https://github.com/pycountry/pycountry/blob/${src.rev}/HISTORY.txt";
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
