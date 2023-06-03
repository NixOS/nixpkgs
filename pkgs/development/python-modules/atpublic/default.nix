{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, pdm-backend
, sybil
}:

buildPythonPackage rec {
  pname = "atpublic";
  version = "3.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iP933eDs2SG7ejH5FPqvixD+wEeL9KiZjzvpxcobR9o=";
  };

  postPatch = ''
    sed -i '/cov=public/d' pyproject.toml
  '';

  nativeBuildInputs = [
    pdm-backend
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sybil
  ];

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
