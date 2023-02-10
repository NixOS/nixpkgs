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
  version = "1.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-N/q9zi2SX38ivSpnjrx+bEzdR9cS2ivSgy42SR8cl+Q=";
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

  pytestFlagsArray = [ "--no-cov" ];

  # these tests invoke git in a subprocess and
  # for some reason git can't be found even if included in nativeCheckInputs
  disabledTests = [
    "test_shims_are_kept"
    "test_shims_are_removed"
  ];

  meta = with lib; {
    homepage = "https://github.com/sarugaku/pythonfinder";
    description = "Cross Platform Search Tool for Finding Pythons";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
