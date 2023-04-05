{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, attrs
, cached-property
, click
, packaging
, pytest-cov
, pytest-timeout
, setuptools
}:

buildPythonPackage rec {
  pname = "pythonfinder";
  version = "1.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sfoAS3QpD78we8HcXpxjSyEIN1xLRVLExaM3oXe6tLU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
    cached-property
    click
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-timeout
  ];

  pythonImportsCheck = [
    "pythonfinder"
  ];

  pytestFlagsArray = [
    "--no-cov"
  ];

  # these tests invoke git in a subprocess and
  # for some reason git can't be found even if included in nativeCheckInputs
  disabledTests = [
    "test_shims_are_kept"
    "test_shims_are_removed"
  ];

  meta = with lib; {
    homepage = "https://github.com/sarugaku/pythonfinder";
    changelog = "https://github.com/sarugaku/pythonfinder/blob/v${version}/CHANGELOG.rst";
    description = "Cross Platform Search Tool for Finding Pythons";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
