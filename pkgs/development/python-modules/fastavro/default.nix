{ buildPythonPackage
, cython
, fetchFromGitHub
, isPy38
, lib
, lz4
, numpy
, pandas
, pytestCheckHook
, python-dateutil
, python-snappy
, pythonOlder
, zstandard
}:

buildPythonPackage rec {
  pname = "fastavro";
<<<<<<< HEAD
  version = "1.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

=======
  version = "1.7.2";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-UPnWVYiZJdP6r7Bm1H9DMXpLi26c9tpXeEkLXVJxWdM=";
=======
    hash = "sha256-IKs3uYGxiSy++tjF2XhWFrIfOo+SSl2JATUHBhCE3ZQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  preBuild = ''
    export FASTAVRO_USE_CYTHON=1
  '';

  nativeBuildInputs = [ cython ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    codecs = [
      lz4
      python-snappy
      zstandard
    ];
    snappy = [
      python-snappy
    ];
    zstandard = [
      zstandard
    ];
    lz4 = [
      lz4
    ];
  };

  nativeCheckInputs = [
=======
  nativeCheckInputs = [
    lz4
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    numpy
    pandas
    pytestCheckHook
    python-dateutil
<<<<<<< HEAD
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);
=======
    python-snappy
    zstandard
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Fails with "AttributeError: module 'fastavro._read_py' has no attribute
  # 'CYTHON_MODULE'." Doesn't appear to be serious. See https://github.com/fastavro/fastavro/issues/112#issuecomment-387638676.
  disabledTests = [ "test_cython_python" ];

  # CLI tests are broken on Python 3.8. See https://github.com/fastavro/fastavro/issues/558.
  disabledTestPaths = lib.optionals isPy38 [ "tests/test_main_cli.py" ];

  pythonImportsCheck = [ "fastavro" ];

  meta = with lib; {
    description = "Fast read/write of AVRO files";
    homepage = "https://github.com/fastavro/fastavro";
<<<<<<< HEAD
    changelog = "https://github.com/fastavro/fastavro/blob/${version}/ChangeLog";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
