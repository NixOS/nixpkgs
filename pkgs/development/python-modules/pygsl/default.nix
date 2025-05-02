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
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygsl";
    repo = "pygsl";
    tag = "v${version}";
    hash = "sha256-1aAc2qGVlClnsw70D1QqPbSsyij0JNgfIXsLzelYx3E=";
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
