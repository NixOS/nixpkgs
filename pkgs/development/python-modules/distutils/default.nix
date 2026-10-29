{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  setuptools-scm,
  setuptools,
  python,
  docutils,
  jaraco-collections,
  jaraco-functools,
  jaraco-envs,
  jaraco-path,
  jaraco-text,
  libz,
  more-itertools,
  packaging,
  path,
  pyfakefs,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage {
  pname = "distutils";
  inherit (setuptools) version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "distutils";
    rev = "5ad8291ff2ad3e43583bc72a4c09299ca6134f09"; # correlate commit from setuptools version
    hash = "sha256-3Mqpe/Goj3lQ6GEbX3DHWjdoh7XsFIg9WkOCK138OAo=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    jaraco-collections
    jaraco-functools
    more-itertools
    packaging
  ];

  postInstall = ''
    rm -r $out/${python.sitePackages}/distutils
    ln -s ${setuptools}/${python.sitePackages}/setuptools/_distutils $out/${python.sitePackages}/distutils
  '';

  pythonImportsCheck = [ "distutils" ];

  nativeCheckInputs = [
    docutils
    jaraco-envs
    jaraco-path
    jaraco-text
    more-itertools
    path
    pyfakefs
    pytestCheckHook
  ];

  checkInputs = [
    # https://github.com/pypa/distutils/blob/5ad8291ff2ad3e43583bc72a4c09299ca6134f09/distutils/tests/test_build_ext.py#L107
    libz
  ];

  # jaraco-path depends ob pyobjc
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    #  AssertionError: assert '(?s:foo[^/]*)\\z' == '(?s:foo[^/]*)\\Z'
    "test_glob_to_re"
  ];

  meta = {
    description = "Distutils as found in cpython";
    homepage = "https://github.com/pypa/distutils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
