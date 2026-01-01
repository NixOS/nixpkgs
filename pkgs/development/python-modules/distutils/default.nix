{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  pythonAtLeast,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools-scm,
  setuptools,
  python,
  docutils,
  jaraco-collections,
  jaraco-functools,
  jaraco-envs,
  jaraco-path,
  jaraco-text,
<<<<<<< HEAD
  libz,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    rev = "5ad8291ff2ad3e43583bc72a4c09299ca6134f09"; # correlate commit from setuptools version
    hash = "sha256-3Mqpe/Goj3lQ6GEbX3DHWjdoh7XsFIg9WkOCK138OAo=";
=======
    rev = "72837514c2b67081401db556be9aaaa43debe44f"; # correlate commit from setuptools version
    hash = "sha256-Kx4Iudy9oZ0oQT96Meyq/m0k0BuexPLVxwvpNJehCW0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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

=======
  # jaraco-path depends ob pyobjc
  doCheck = !stdenv.hostPlatform.isDarwin;

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Distutils as found in cpython";
    homepage = "https://github.com/pypa/distutils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
