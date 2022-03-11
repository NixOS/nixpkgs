{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
, pytest-flake8
, glibcLocales
, packaging
, isPy38
, importlib-metadata
, fetchpatch
}:

buildPythonPackage rec {
  pname = "path";
  version = "15.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "u2Ka79hoJb8hyLz6D4aRpuWr3D5D1Qtib+aqxbE/YLc=";
  };

  checkInputs = [ pytestCheckHook pytest-flake8 glibcLocales packaging ];
  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    importlib-metadata
  ];

  LC_ALL = "en_US.UTF-8";

  meta = {
    description = "A module wrapper for os.path";
    homepage = "https://github.com/jaraco/path";
    license = lib.licenses.mit;
  };

  # ignore performance test which may fail when the system is under load
  # test_version fails with 3.8 https://github.com/jaraco/path.py/issues/172
  disabledTests = [ "TestPerformance" ];

  dontUseSetuptoolsCheck = true;
}
