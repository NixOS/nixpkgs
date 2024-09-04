{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  setuptools,
  python,
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
    rev = "813ab9868b353991ec7324eb09619ee5beb9183f";
    hash = "sha256-/YtITDuZlTJRisqsQ6SrgRRUrqLZpj+k3drrouURZlc=";
  };

  build-system = [ setuptools-scm ];

  postInstall = ''
    rm -r $out/${python.sitePackages}/distutils
    ln -s ${setuptools}/${python.sitePackages}/setuptools/_distutils $out/${python.sitePackages}/distutils
  '';

  pythonImportsCheck = [ "distutils" ];

  nativeCheckInputs = [
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
