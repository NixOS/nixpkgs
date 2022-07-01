{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, pdm-pep517
, sybil
, typing-extensions
}:

buildPythonPackage rec {
  pname = "atpublic";
  version = "3.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb072b50e6484490404e5cb4034e782aaa339fdd6ac36434e53c10791aef18bf";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    sybil
  ];

  postPatch = ''
    sed -i '/cov=public/d' pyproject.toml
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
