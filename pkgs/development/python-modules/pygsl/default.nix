{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  gsl,
  swig,
  meson-python,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygsl";
  version = "2.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygsl";
    repo = "pygsl";
    tag = "v${version}";
    hash = "sha256-dZIWOwRRrF1bux9UTIxN31/S380wPT4gpQ/gYbUO4FQ=";
  };

  nativeBuildInputs = [
    pkg-config
    swig
  ];
  buildInputs = [
    gsl
  ];

  build-system = [
    meson-python
    numpy
  ];
  dependencies = [
    numpy
  ];

  preCheck = ''
    cd tests
  '';
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python interface for GNU Scientific Library";
    homepage = "https://github.com/pygsl/pygsl";
    changelog = "https://github.com/pygsl/pygsl/blob/${src.tag}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
