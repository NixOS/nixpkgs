{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyjwt,
  ratelimit,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "pyflume";
  version = "0.8.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ChrisMandich";
    repo = "PyFlume";
    tag = "v${version}";
    hash = "sha256-/8gLKe+6GaPQe0J3YBmOVcAcAcqfrWM7UQCoX+qOEmw=";
  };

  propagatedBuildInputs = [
    pyjwt
    ratelimit
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyflume" ];

  meta = {
    description = "Python module to work with Flume sensors";
    homepage = "https://github.com/ChrisMandich/PyFlume";
    changelog = "https://github.com/ChrisMandich/PyFlume/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
