{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gsl,
  swig,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygsl";
  version = "2.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pygsl";
    repo = "pygsl";
    tag = "v${version}";
    hash = "sha256-ym7wCCaqY1y4Q7LDaNfGoao//DcG+H/6Fmg0YZUThOU=";
  };

  # error: no member named 'n' in 'gsl_bspline_workspace'
  postPatch = lib.optionalString (lib.versionAtLeast gsl.version "2.8") ''
    substituteInPlace src/bspline/bspline.ic \
      --replace-fail "self->w->n" "self->w->ncontrol"
    substituteInPlace swig_src/bspline_wrap.c \
      --replace-fail "self->w->n;" "self->w->ncontrol;"
  '';

  nativeBuildInputs = [
    gsl.dev
    swig
  ];
  buildInputs = [ gsl ];
  dependencies = [ numpy ];

  preBuild = ''
    python setup.py build_ext --inplace
  '';

  preCheck = ''
    cd tests
  '';
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python interface for GNU Scientific Library";
    homepage = "https://github.com/pygsl/pygsl";
    changelog = "https://github.com/pygsl/pygsl/blob/v${version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
