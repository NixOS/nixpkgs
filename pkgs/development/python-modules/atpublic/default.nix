{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, hatchling
, sybil
, typing-extensions
}:

buildPythonPackage rec {
  pname = "atpublic";
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0cjNkxr3Rh9tGLxgYzg+hlTZ6e8Z1Y7m3AHoUVu/Vd8=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sybil
  ];

  pytestFlagsArray = [
    # TypeError: FixtureManager.getfixtureclosure() missing 1 required positional argument: 'ignore_args'
    "--ignore=docs/using.rst"
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
