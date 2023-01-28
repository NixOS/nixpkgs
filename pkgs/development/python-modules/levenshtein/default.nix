{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cmake
, cython
, pytestCheckHook
, rapidfuzz
, rapidfuzz-cpp
, scikit-build
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.20.9";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "refs/tags/v${version}";
    hash = "sha256-BPfv3XsAaspLGmztllUYLq6VMKaW+s/Pp18RQmSrilc=";
  };

  nativeBuildInputs = [
    cmake
    cython
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    rapidfuzz-cpp
  ];

  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.cc.isClang && stdenv.isDarwin) [
    "-fno-lto"  # work around https://github.com/NixOS/nixpkgs/issues/19098
  ];

  propagatedBuildInputs = [
    rapidfuzz
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "Levenshtein"
  ];

  meta = with lib; {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage = "https://github.com/maxbachmann/Levenshtein";
    changelog = "https://github.com/maxbachmann/Levenshtein/blob/${version}/HISTORY.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
