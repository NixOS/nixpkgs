{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  strct,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "birch";
  version = "0.0.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaypal5";
    repo = "birch";
    rev = "v${version}";
    hash = "sha256-KdQZzQJvJ+logpcLQfaqqEEZJ/9VmNTQX/a4v0oBC98=";
  };

  patches = [
    # https://github.com/shaypal5/birch/pull/4
    (fetchpatch {
      name = "fix-versioneer-on-python312.patch";
      url = "https://github.com/shaypal5/birch/commit/84d597b2251ebb76fb15fb70fc86c83baa19dc0b.patch";
      hash = "sha256-xXADCSIhq1ARny2twzrhR1J8LkMFWFl6tmGxrM8RvkU=";
    })
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail  \
        "--cov" \
        "#--cov"

    # configure correct version, which fails due to missing .git
    substituteInPlace versioneer.py birch/_version.py \
      --replace-fail '"0+unknown"' '"${version}"'
  '';

  nativeBuildInputs = [ setuptools ];

  dependencies = [ strct ];

  pythonImportsCheck = [
    "birch"
    "birch.casters"
    "birch.exceptions"
    "birch.paths"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "Simple hierarchical configuration for Python packages";
    homepage = "https://github.com/shaypal5/birch";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
