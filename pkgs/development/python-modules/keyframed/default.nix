{ lib
, buildPythonPackage
, fetchFromGitHub

, sortedcontainers
, omegaconf
, matplotlib

, pytestCheckHook
, loguru
}:

buildPythonPackage rec {
  pname = "keyframed";
  version = "0.3.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dmarx";
    repo = "keyframed";
    rev = "refs/tags/v${version}";
    hash = "sha256-GjuTYmDI/l2H8g/yqJbZVmj4cwgxdDd7gqi0Un5B85U=";
  };

  propagatedBuildInputs = [
    sortedcontainers
    omegaconf
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    loguru
  ];

  pythonImportsCheck = [
    "keyframed"
  ];

  meta = {
    homepage = "https://github.com/dmarx/keyframed";
    description = "Simple, expressive datatypes for manipulating parameter curves";
    changelog = "https://github.com/dmarx/keyframed/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
