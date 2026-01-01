{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # Python Dependencies
  six,
  urllib3,
  requests,

  # tests
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "mixpanel";
  version = "4.10.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mixpanel";
    repo = "mixpanel-python";
    tag = "v${version}";
    hash = "sha256-i5vT5FTnw+BanHHrlRsPJ3EooZjQcaosbaHoh/uPRmQ=";
  };

  propagatedBuildInputs = [
    requests
    six
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/mixpanel/mixpanel-python";
    description = "Official Mixpanel Python library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
=======
  meta = with lib; {
    homepage = "https://github.com/mixpanel/mixpanel-python";
    description = "Official Mixpanel Python library";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamadorueda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
