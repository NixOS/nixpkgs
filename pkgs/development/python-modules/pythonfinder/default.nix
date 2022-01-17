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
, backports_functools_lru_cache
, pathlib2
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
  ]
  ++ lib.optionals (pythonOlder "3.5") [ pathlib2 ]
  ++ lib.optionals (pythonOlder "3") [ backports_functools_lru_cache ];

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
