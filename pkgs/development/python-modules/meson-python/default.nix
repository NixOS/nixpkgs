{ lib
, stdenv
, buildPythonPackage
, colorama
, cython
, fetchPypi
, git
, meson
, ninja
, pyproject-metadata
, pytest-mock
, pytestCheckHook
, pythonOlder
, tomli
, typing-extensions
, wheel
}:

buildPythonPackage rec {
  pname = "meson-python";
  version = "0.13.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-gLyd6Jis0260uUWvqveitMoAGJxRhw1TXjKXYZEM+Oo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pyproject-metadata
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  propagatedBuildInputs = [
    meson
    ninja
    pyproject-metadata
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [
    cython
    git
    pytest-mock
    pytestCheckHook
    wheel
  ];

  pythonImportsCheck = [
    "mesonpy"
  ];

  disabledTestPaths = [
    # Issue with subprocess
    "tests/test_pep518.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/mesonbuild/meson-python/blob/${version}/CHANGELOG.rst";
    description = "Meson Python build backend (PEP 517)";
    homepage = "https://github.com/mesonbuild/meson-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fridh ];
  };
}
