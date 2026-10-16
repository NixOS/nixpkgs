{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libsass,
  setuptools_80,
  pytestCheckHook,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "libsass";
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sass";
    repo = "libsass-python";
    tag = finalAttrs.version;
    hash = "sha256-CiSr9/3EDwpDEzu6VcMBAlm3CtKTmGYbZMnMEjyZVxI=";
  };

  build-system = [ setuptools_80 ];

  buildInputs = [ libsass ];

  env.SYSTEM_SASS = "true";

  nativeCheckInputs = [
    pytestCheckHook
    werkzeug
  ];

  enabledTestPaths = [ "sasstests.py" ];

  pythonImportsCheck = [ "sass" ];

  meta = {
    description = "Python binding for libsass to compile Sass/SCSS";
    mainProgram = "pysassc";
    homepage = "https://sass.github.io/libsass-python/";
    downloadPage = "https://github.com/sass/libsass-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
