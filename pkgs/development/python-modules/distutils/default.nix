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
  more-itertools,
  packaging,
  path,
  pyfakefs,
  pytestCheckHook,
  zlib,
  stdenv,
}:

buildPythonPackage {
  pname = "distutils";
  inherit (setuptools) version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "distutils";
    rev = "f10ac6219960991c98b821cf2544bf9c2864ebc2"; # correlate commit from setuptools version
    hash = "sha256-KzC7zvrC7fsAQhLFZvep/F+yDRzsBDYtir1EA7gdpGM=";
  };

  postPatch = ''
    sed -i '/coherent\.licensed/d' pyproject.toml
  '';

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
    zlib
  ];

  # jaraco-path depends ob pyobjc
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    #  TypeError: byte_compile() got an unexpected keyword argument 'dry_run'
    "test_byte_compile"
    "test_byte_compile_optimized"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
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
