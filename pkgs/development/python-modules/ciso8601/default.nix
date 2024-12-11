{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "ciso8601";
  version = "2.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "closeio";
    repo = "ciso8601";
    tag = "v${version}";
    hash = "sha256-oVnQ0vHhWs8spfOnJOgTJ6MAHcY8VGZHZ0E/T8JsKqE=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  pytestFlagsArray = [ "tests/tests.py" ];

  pythonImportsCheck = [ "ciso8601" ];

  meta = with lib; {
    description = "Fast ISO8601 date time parser for Python written in C";
    homepage = "https://github.com/closeio/ciso8601";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
