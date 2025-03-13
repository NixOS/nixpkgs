{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  fzf,
  packaging,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "iterfzf";
  version = "1.5.0.60.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "iterfzf";
    tag = version;
    hash = "sha256-9WN49tY9wWBVQGXCpvNQlRaRCZWSfV4xrZPoIOVjK9g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"' \
      --replace-fail 'backend-path = ["."]' '# backend-path = ["."]' \
      --replace-fail 'build-backend = "build_dist"' '# build-backend = "build_dist"'

    substituteInPlace iterfzf/test_iterfzf.py \
      --replace-fail 'executable="fzf"' 'executable="${fzf}/bin/fzf"'
  '';

  build-system = [
    flit-core
    setuptools
    packaging
  ];

  dependencies = [ fzf ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AttributeError
    "test_no_query"
    "test_select_one_ambiguous"
  ];

  pythonImportsCheck = [ "iterfzf" ];

  meta = with lib; {
    description = "Pythonic interface to fzf, a CLI fuzzy finder";
    homepage = "https://github.com/dahlia/iterfzf";
    changelog = "https://github.com/dahlia/iterfzf/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
