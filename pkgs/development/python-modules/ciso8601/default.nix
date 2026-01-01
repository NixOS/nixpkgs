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
<<<<<<< HEAD
  version = "2.3.3";
=======
  version = "2.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "closeio";
    repo = "ciso8601";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-14HiCn8BPALPaW53k118lHb5F4oG9mMNN6sdLdKB6v0=";
=======
    hash = "sha256-oVnQ0vHhWs8spfOnJOgTJ6MAHcY8VGZHZ0E/T8JsKqE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  enabledTestPaths = [ "tests/tests.py" ];

  pythonImportsCheck = [ "ciso8601" ];

<<<<<<< HEAD
  meta = {
    description = "Fast ISO8601 date time parser for Python written in C";
    homepage = "https://github.com/closeio/ciso8601";
    changelog = "https://github.com/closeio/ciso8601/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
=======
  meta = with lib; {
    description = "Fast ISO8601 date time parser for Python written in C";
    homepage = "https://github.com/closeio/ciso8601";
    changelog = "https://github.com/closeio/ciso8601/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
