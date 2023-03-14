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
  version = "3.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MJjuEtAQfMUAnWH06A5e3PrEzaK9qgRkSvdYJ8sSGxg=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
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
