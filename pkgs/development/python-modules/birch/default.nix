{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, strct
, pytestCheckHook
, pyyaml
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

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace  \
        "--cov" \
        "#--cov"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    strct
  ];

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
