{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pygobject3,
}:

buildPythonPackage rec {
  pname = "pydbus";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LEW21";
    repo = "pydbus";
    rev = "refs/tags/v${version}";
    hash = "sha256-F1KKXG+7dWlEbToqtF3G7wU0Sco7zH5NqzlL58jyDGw=";
  };

  postPatch = ''
    substituteInPlace pydbus/_inspect3.py \
      --replace "getargspec" "getfullargspec"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pygobject3 ];

  pythonImportsCheck = [
    "pydbus"
    "pydbus.generic"
  ];

  doCheck = false; # requires a working dbus setup

  meta = {
    homepage = "https://github.com/LEW21/pydbus";
    description = "Pythonic DBus library";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
  };
}
