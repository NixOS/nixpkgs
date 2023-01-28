{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-xdist
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, schema-salad
}:

buildPythonPackage rec {
  pname = "cwl-upgrader";
  version = "1.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3pKnkU8lks3w+N7w2qST9jr4/CS6YzgnBVLTlgq1gf0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ruamel.yaml >= 0.15, < 0.17.22" "ruamel.yaml" \
      --replace "setup_requires=PYTEST_RUNNER," ""
    sed -i "/ruamel.yaml/d" setup.py
  '';

  propagatedBuildInputs = [
    ruamel-yaml
    schema-salad
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cwlupgrader"
  ];

  meta = with lib; {
    description = "Library to interface with Yolink";
    homepage = "https://github.com/common-workflow-language/cwl-utils";
    changelog = "https://github.com/common-workflow-language/cwl-utils/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
