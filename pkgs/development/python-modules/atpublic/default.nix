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
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb072b50e6484490404e5cb4034e782aaa339fdd6ac36434e53c10791aef18bf";
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
