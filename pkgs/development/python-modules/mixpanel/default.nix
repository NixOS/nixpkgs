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
  version = "5.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mixpanel";
    repo = "mixpanel-python";
    tag = "v${version}";
    hash = "sha256-B87i6wwI/JpZXY58mk7CC+9+Q0w6UwxYX/h/fp2m9aQ=";
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

  meta = {
    homepage = "https://github.com/mixpanel/mixpanel-python";
    description = "Official Mixpanel Python library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
