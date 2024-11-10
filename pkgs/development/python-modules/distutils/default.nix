{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  setuptools,
  python,
  jaraco-collections,
  jaraco-functools,
  jaraco-envs,
  jaraco-path,
  jaraco-text,
  more-itertools,
  path,
  pyfakefs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "distutils";
  inherit (setuptools) version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "distutils";
    rev = "378984e02edae91d5f49425da8436f8dd9152b8a"; # correlate commit from setuptools version
    hash = "sha256-31sPPVY6tr+OwpiFiaKw82KyhDNBVW3Foea49dCa6pA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ jaraco-functools ];

  postInstall = ''
    rm -r $out/${python.sitePackages}/distutils
    ln -s ${setuptools}/${python.sitePackages}/setuptools/_distutils $out/${python.sitePackages}/distutils
  '';

  pythonImportsCheck = [ "distutils" ];

  nativeCheckInputs = [
    jaraco-collections
    jaraco-envs
    jaraco-path
    jaraco-text
    more-itertools
    path
    pyfakefs
    pytestCheckHook
  ];

  meta = {
    description = "Distutils as found in cpython";
    homepage = "https://github.com/pypa/distutils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
