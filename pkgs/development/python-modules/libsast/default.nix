{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  pytestCheckHook,

  semgrep,

  requests,
  pyyaml,
  billiard,
}:

buildPythonPackage rec {
  pname = "libsast";
  version = "3.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ajinabraham";
    repo = "libsast";
    rev = "refs/tags/${version}";
    hash = "sha256-A02VcSgd58m7ZomvAz0TBEe8hRZhx29jAjYl48fwPKg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    pyyaml
    billiard
  ];

  pythonImportsCheck = [ "libsast" ];

  nativeCheckInputs = [
    pytestCheckHook

    semgrep
  ];

  # These require an internet connection
  disabledTests = [
    "test_load_url"
    "test_semgrep"
  ];

  meta = {
    description = "Generic SAST for Security Engineers. Powered by regex based pattern matcher and semantic aware semgrep";
    homepage = "https://github.com/ajinabraham/libsast";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
