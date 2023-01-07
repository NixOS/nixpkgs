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
  version = "1.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-o9IAk3EN8ghEft7Y7Xx+sEjWMNgoyiZ0eiBqnCyXkm8=";
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
