{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libsass,
  six,
  pytestCheckHook,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "libsass";
  version = "0.23.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "libsass-python";
    rev = "refs/tags/${version}";
    hash = "sha256-CiSr9/3EDwpDEzu6VcMBAlm3CtKTmGYbZMnMEjyZVxI=";
  };

  buildInputs = [ libsass ];

  propagatedBuildInputs = [ six ];

  preBuild = ''
    export SYSTEM_SASS=true;
  '';

  nativeCheckInputs = [
    pytestCheckHook
    werkzeug
  ];

  pytestFlagsArray = [ "sasstests.py" ];

  pythonImportsCheck = [ "sass" ];

  meta = {
    description = "Python binding for libsass to compile Sass/SCSS";
    mainProgram = "pysassc";
    homepage = "https://sass.github.io/libsass-python/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
