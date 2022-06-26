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
  version = "1.0.4";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "JaroWinkler";
    rev = "v${version}";
    hash = "sha256-2bhKl7l3ByfrtkXnXifQd/AhWVFGSMzULkzJftd1mVE=";
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

  dontUseCmakeConfigure = true;

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm -r jarowinkler
  '';

  pythonImportsCheck = [ "jarowinkler" ];

  meta = with lib; {
    description = "Library for fast approximate string matching using Jaro and Jaro-Winkler similarity";
    homepage = "https://github.com/maxbachmann/JaroWinkler";
    changelog = "https://github.com/maxbachmann/JaroWinkler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
