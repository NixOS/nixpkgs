{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  stdenv,
}:

buildPythonPackage {
  pname = "distutils";
  inherit (setuptools) version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "distutils";
    rev = "72837514c2b67081401db556be9aaaa43debe44f"; # correlate commit from setuptools version
    hash = "sha256-Kx4Iudy9oZ0oQT96Meyq/m0k0BuexPLVxwvpNJehCW0=";
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

  # jaraco-path depends ob pyobjc
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Distutils as found in cpython";
    homepage = "https://github.com/pypa/distutils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
