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
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = pname;
    rev = version;
    hash = "sha256-n/Q6yt3q/+6QCGWNmaFrUK/phba6IVu42DMcvVj4vb0=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
