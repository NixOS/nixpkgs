{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, sybil
, typing-extensions
}:

buildPythonPackage rec {
  pname = "atpublic";
  version = "2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6b9167fc3e09a2de2d2adcfc9a1b48d84eab70753c97de3800362e1703e3367";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    sybil
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=public" ""
  '';

  pythonImportsCheck = [
    "public"
  ];

  meta = with lib; {
    description = "Python decorator and function which populates a module's __all__ and globals";
    homepage = "https://public.readthedocs.io/";
    longDescription = ''
      This is a very simple decorator and function which populates a module's
      __all__ and optionally the module globals.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
