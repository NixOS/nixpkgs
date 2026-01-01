{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "astor";
  version = "0.8.1-unstable-2024-03-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "berkerpeksag";
    repo = "astor";
    rev = "df09001112f079db54e7c5358fa143e1e63e74c4";
    hash = "sha256-VF+harl/q2yRU2yqN1Txud3YBNSeedQNw2SZNYQFsno=";
  };

  patches = [
    # https://github.com/berkerpeksag/astor/pull/233
    ./python314-compat.patch
  ];

  build-system = [ setuptools ];

=======
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "astor";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ppscdzzvxpznclkmhhj53iz314x3pfv4yc7c6gwxqgljgdgyvka";
  };

  # disable tests broken with python3.6: https://github.com/berkerpeksag/astor/issues/89
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/berkerpeksag/astor/issues/196
    "test_convert_stdlib"
<<<<<<< HEAD
  ];

  passthru.updateScript = unstableGitUpdater {
    branch = "master";
  };

  meta = {
    description = "Library for reading, writing and rewriting python AST";
    homepage = "https://github.com/berkerpeksag/astor";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nixy ];
=======
    # https://github.com/berkerpeksag/astor/issues/212
    "test_huge_int"
  ];

  meta = with lib; {
    description = "Library for reading, writing and rewriting python AST";
    homepage = "https://github.com/berkerpeksag/astor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
