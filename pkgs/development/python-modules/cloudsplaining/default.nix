{ lib
, boto3
, botocore
, buildPythonPackage
, cached-property
, click
, click-option-group
, fetchFromGitHub
, jinja2
, markdown
, policy-sentry
, pytestCheckHook
, pythonOlder
, pyyaml
, schema
}:

buildPythonPackage rec {
  pname = "cloudsplaining";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Bw1RhYFTz1bw+4APZKTyWP/G+LWB3R9WI/QEduEgWTQ=";
=======
    hash = "sha256-L7sEv0xe8+riJb7DW2N6+MsoXBXJNzK96oGkpAkAyLU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    boto3
    botocore
    cached-property
    click
    click-option-group
    jinja2
    markdown
    policy-sentry
    pyyaml
    schema
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" requirements.txt
  '';

  disabledTests = [
    "test_policy_expansion"
    "test_statement_details_for_allow_not_action"
  ];

  pythonImportsCheck = [
    "cloudsplaining"
  ];

  meta = with lib; {
    description = "Python module for AWS IAM security assessment";
    homepage = "https://github.com/salesforce/cloudsplaining";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
