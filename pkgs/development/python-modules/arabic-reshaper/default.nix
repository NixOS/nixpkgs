{ lib
, buildPythonPackage
, fetchFromGitHub
, fonttools
, future
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "arabic-reshaper";
  version = "2.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mpcabd";
    repo = "python-arabic-reshaper";
    rev = "v${version}";
    hash = "sha256-qQGIC/KequOQZoxwm7AEkdPV0QpS7YoBV9v8ZA7AYQM=";
  };

  propagatedBuildInputs = [
    future
  ];

  passthru.optional-dependencies = {
    with-fonttools = [
      fonttools
    ];
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "arabic_reshaper"
  ];

  meta = with lib; {
    description = "Reconstruct Arabic sentences to be used in applications that don't support Arabic";
    homepage = "https://github.com/mpcabd/python-arabic-reshaper";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ freezeboy ];
  };
}
