{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytestCheckHook
, pytest-flake8
, glibcLocales
, packaging
, isPy38
, importlib-metadata
, fetchpatch
}:

buildPythonPackage rec {
  pname = "path.py";
  version = "12.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f2169633403aa0423f6ec000e8701dd1819526c62465f5043952f92527fea0f";
  };

  checkInputs = [ pytestCheckHook pytest-flake8 glibcLocales packaging ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    importlib-metadata
  ];

  LC_ALL = "en_US.UTF-8";

  meta = {
    description = "A module wrapper for os.path";
    homepage = "https://github.com/jaraco/path.py";
    license = lib.licenses.mit;
  };

  # ignore performance test which may fail when the system is under load
  # test_version fails with 3.8 https://github.com/jaraco/path.py/issues/172
  disabledTests = [ "TestPerformance" ] ++ lib.optionals isPy38 [ "test_version"];

  dontUseSetuptoolsCheck = true;

  patches = [
    (fetchpatch {
      url = "https://github.com/jaraco/path.py/commit/02eb16f0eb2cdc0015972ce963357aaa1cd0b84b.patch";
      sha256 = "0bqa8vjwil7jn35a6984adcm24pvv3pjkhszv10qv6yr442d1mk9";
    })
  ];

}
