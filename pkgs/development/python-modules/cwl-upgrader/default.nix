{ lib
, buildPythonPackage
, fetchFromGitHub
, mypy-extensions
, pytest-xdist
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, schema-salad
}:

buildPythonPackage rec {
  pname = "cwl-upgrader";
<<<<<<< HEAD
  version = "1.2.9";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "1.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-yvgGMGo4QK+PRDzqlOH4rP49fnJUlbYB9B5AnlX+LF8=";
=======
    hash = "sha256-lVIy0aa+hqbi46NfwXCKWDRzszneyuyo6KXxAcr/xIA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ruamel.yaml >= 0.15, < 0.17.22" "ruamel.yaml" \
      --replace "setup_requires=PYTEST_RUNNER," ""
    sed -i "/ruamel.yaml/d" setup.py
  '';

  propagatedBuildInputs = [
    mypy-extensions
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
