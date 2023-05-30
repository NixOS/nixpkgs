{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flit-core
, pytestCheckHook
, mdformat
, mdit-py-plugins
, ruamel-yaml
,
}:
buildPythonPackage rec {
  pname = "mdformat-frontmatter";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "butler54";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PhT5whtvvcYSs5gHQEsIvV1evhx7jR+3DWFMHrF0uMw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
    ruamel-yaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mdformat_frontmatter"
  ];

  meta = with lib; {
    description = "An mdformat plugin for rendering tables";
    homepage = "https://github.com/executablebooks/mdformat-tables";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ polarmutex ];
  };
}
