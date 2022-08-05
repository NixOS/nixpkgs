################################################################################
# WARNING: Changes made to this file MUST go through the usual PR review process
#          and MUST be approved by a member of `meta.maintainers` before
#          merging. Commits attempting to circumvent the PR review process -- as
#          part of python-updates or otheriwse -- will be reverted without
#          notice.
################################################################################
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
  version = "1.5.3";

  disabled = pythonOlder "3.6";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-6Zs4Whf/9c829D3tHvrhOzVRjYzqomcT9wzrBCklQmc=";
  };

  preBuild = ''
    export FASTAVRO_USE_CYTHON=1
  '';

  nativeBuildInputs = [ cython ];

  checkInputs = [
    lz4
    numpy
    pandas
    pytestCheckHook
    python-dateutil
    python-snappy
    zstandard
  ];

  # Fails with "AttributeError: module 'fastavro._read_py' has no attribute
  # 'CYTHON_MODULE'." Doesn't appear to be serious. See https://github.com/fastavro/fastavro/issues/112#issuecomment-387638676.
  disabledTests = [ "test_cython_python" ];

  # CLI tests are broken on Python 3.8. See https://github.com/fastavro/fastavro/issues/558.
  disabledTestPaths = lib.optionals isPy38 [ "tests/test_main_cli.py" ];

  pythonImportsCheck = [ "fastavro" ];

  meta = with lib; {
    description = "Fast read/write of AVRO files";
    homepage = "https://github.com/fastavro/fastavro";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
