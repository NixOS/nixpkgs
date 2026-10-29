{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # Fix gcc 15 -Wincompatible-pointer-types errors in arraycopy.c.
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/pygsl/raw/c35177ef7f8f5104a2b96a87d909248140ee6009/f/pygsl-incompatible-pointer.patch";
      hash = "sha256-o7hZScnRqD7rxRn2EOxoys2F1U4GVOS9BmcxjTsh/vc=";
    })
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
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
