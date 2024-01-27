{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cmake
, cython_3
, pytestCheckHook
, rapidfuzz
, rapidfuzz-cpp
, scikit-build
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.23.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "refs/tags/v${version}";
    hash = "sha256-xQimslz/G6nf2uYerLSaRAK5gvmfDmWTzEx/fh+nqg0=";
    fetchSubmodules = true; ## for vendored `rapidfuzz-cpp`
  };

  nativeBuildInputs = [
    cmake
    cython_3
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    rapidfuzz-cpp
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.cc.isClang && stdenv.isDarwin) [
    "-fno-lto"  # work around https://github.com/NixOS/nixpkgs/issues/19098
  ]);

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
    changelog = "https://github.com/maxbachmann/Levenshtein/blob/${src.rev}/HISTORY.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
