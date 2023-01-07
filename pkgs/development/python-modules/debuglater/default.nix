{ lib
, buildPythonPackage
, colorama
, dill
, fetchFromGitHub
, numpy
, pandas
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "debuglater";
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0fnWXmrlZjlLFGbiLC7HuDgMEM6OJVn8ajjNRqFg3Lc=";
  };

  propagatedBuildInputs = [
    colorama
  ];

  passthru.optional-dependencies = {
    all = [
      dill
    ];
  };

  checkInputs = [
    numpy
    pandas
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  pythonImportsCheck = [
    "debuglater"
  ];

  meta = with lib; {
    description = "Module for post-mortem debugging of Python programs";
    homepage = "https://github.com/ploomber/debuglater";
    changelog = "https://github.com/ploomber/debuglater/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
