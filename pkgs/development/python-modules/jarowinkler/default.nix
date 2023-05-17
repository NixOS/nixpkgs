{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, ninja
, cython
, rapidfuzz-capi
, scikit-build
, setuptools
, jarowinkler-cpp
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jarowinkler";
  version = "1.2.3";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "JaroWinkler";
    rev = "refs/tags/v${version}";
    hash = "sha256-j+ZabVsiVitNkTPhGjDg72XogjvPaL453lTW45ITm90=";
  };

  nativeBuildInputs = [
    cmake
    cython
    ninja
    rapidfuzz-capi
    scikit-build
    setuptools
  ];

  buildInputs = [
    jarowinkler-cpp
  ];

  preBuild = ''
    export JAROWINKLER_BUILD_EXTENSION=1
  '';

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jarowinkler" ];

  meta = with lib; {
    description = "Library for fast approximate string matching using Jaro and Jaro-Winkler similarity";
    homepage = "https://github.com/maxbachmann/JaroWinkler";
    changelog = "https://github.com/maxbachmann/JaroWinkler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
