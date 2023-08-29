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
, wheel
, jarowinkler-cpp
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jarowinkler";
  version = "1.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "JaroWinkler";
    rev = "refs/tags/v${version}";
    hash = "sha256-j+ZabVsiVitNkTPhGjDg72XogjvPaL453lTW45ITm90=";
  };

  # We cannot use Cython version 3.0.0 because the code in jarowinkler has not
  # been adapted for https://github.com/cython/cython/issues/4280 yet
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'scikit-build==' 'scikit-build>=' \
      --replace 'Cython==3.0.0a11' 'Cython'
  '';

  nativeBuildInputs = [
    cmake
    cython
    ninja
    rapidfuzz-capi
    scikit-build
    setuptools
    wheel
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
