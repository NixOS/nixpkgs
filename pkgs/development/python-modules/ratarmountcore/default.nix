{ lib
, buildPythonPackage
, fetchgit
, pythonOlder
, pytestCheckHook
, indexed-bzip2
, indexed-gzip
, indexed-zstd
, python-xz
, rapidgzip
, rarfile
, zstandard     # Python bindings
, zstd          # System tool
}:

buildPythonPackage rec {
  pname = "ratarmountcore";
  version = "0.6.0";

  disabled = pythonOlder "3.6";

  src = fetchgit {
    url = "https://github.com/mxmlnkn/ratarmount";
    # The revision is hardcoded for now to fix problems with the tests, which are not worthy of a new release
    # tag because releases do not officially contain tests. On the next release, use the commented revision,
    # which points to a release tag, instead.
    #rev = "core-v${version}";
    rev = "ea43572dfbac4770a27ef2169f72ff73ee4a4ae9";
    hash = "sha256-sPApM5OW+UbujFXHSL4ptMaegajz7FNtXz/KftTlw+U=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/core";

  propagatedBuildInputs = [ indexed-gzip indexed-bzip2 indexed-zstd python-xz rapidgzip rarfile ];

  pythonImportsCheck = [ "ratarmountcore" ];

  nativeCheckInputs = [ pytestCheckHook zstandard zstd ];

  meta = with lib; {
    description = "Library for accessing archives by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount/tree/master/core";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = platforms.all;
  };
}
