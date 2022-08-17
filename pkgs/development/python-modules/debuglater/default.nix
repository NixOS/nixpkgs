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
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = pname;
    rev = version;
    hash = "sha256-6XIBPnH2LWc3GpSS8Eh2VG21v8+Em7cmvmQIJKzFi6M=";
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
