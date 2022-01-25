{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, attrs
, cached-property
, click
, six
, packaging
, pytest-cov
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "pythonfinder";
  version = "1.2.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = version;
    sha256 = "sha256-tPMqVKbYwBRvb8/GyYNxO8lwJLcUUQyRoCoF5tg6rxs=";
  };

  propagatedBuildInputs = [
    attrs
    cached-property
    click
    six
    packaging
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-timeout
  ];

  pytestFlagsArray = [ "--no-cov" ];

  # these tests invoke git in a subprocess and
  # for some reason git can't be found even if included in checkInputs
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
