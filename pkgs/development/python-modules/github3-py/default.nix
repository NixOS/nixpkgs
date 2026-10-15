{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  uritemplate,
  python-dateutil,
  pyjwt,
  pytest-xdist,
  pytestCheckHook,
  betamax,
  betamax-matchers,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "github3-py";
  version = "4.0.1-unstable-2026-04-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sigmavirus24";
    repo = "github3.py";
    rev = "9eeac0ddb241bf3099a6c904411e3aa23b62fd0d";
    hash = "sha256-iaI9FqsPGM5R7JGoG+qRdQygMzbYUDX28j1S/IeLfrA=";
  };

  patches = [
    # https://github.com/sigmavirus24/github3.py/pull/1359
    ./0001-fix-tests-with-requests-2.34.patch
  ];

  build-system = [ hatchling ];

  dependencies = [
    pyjwt
    python-dateutil
    requests
    uritemplate
  ]
  ++ pyjwt.optional-dependencies.crypto;

  pythonImportsCheck = [ "github3" ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    betamax
    betamax-matchers
  ];

  meta = {
    homepage = "https://github3py.readthedocs.org/en/master/";
    description = "Wrapper for the GitHub API written in python";
    changelog = "https://github.com/sigmavirus24/github3.py/blob/${finalAttrs.version}/docs/source/release-notes/${finalAttrs.version}.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
