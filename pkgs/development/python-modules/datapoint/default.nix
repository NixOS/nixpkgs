{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  appdirs,
  pytz,
  requests,
  pytestCheckHook,
  requests-mock,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "datapoint";
  version = "0.9.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ejep";
    repo = "datapoint-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-zUvwfBwJe8SaB96/Jz7Qeanz1mHmLVp2JW9qkR2dRnY=";
  };

  patches = [
    (fetchpatch2 {
      # Hardcode version (instead of using versioneer)
      url = "https://github.com/EJEP/datapoint-python/commit/57e649b26ecf39fb11f507eb920b1d059d433721.patch";
      hash = "sha256-trOPtwlaJDeA4Kau4fwZCxqJiw96+T/le461t09O8io=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    appdirs
    pytz
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "datapoint" ];

  meta = {
    description = "Python interface to the Met Office's Datapoint API";
    homepage = "https://github.com/ejep/datapoint-python";
    changelog = "https://github.com/EJEP/datapoint-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
