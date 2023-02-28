{ lib
, fetchFromGitHub
, buildPythonPackage
, importlib-metadata
, importlib-resources
, setuptools
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fake-useragent";
  version = "1.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fake-useragent";
    repo = "fake-useragent";
    rev = "refs/tags/${version}";
    hash = "sha256-Rz+oEpgfvSRdly+H1bYxYjNCfo1STkLcogPgZs+b8DY=";
  };

  postPatch = ''
    sed -i '/addopts/d' pytest.ini
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Up to date simple useragent faker with real world database";
    homepage = "https://github.com/hellysmile/fake-useragent";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
