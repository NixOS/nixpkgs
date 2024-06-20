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
  version = "2.3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pygsl";
    repo = "pygsl";
    rev = "refs/tags/v.${version}";
    hash = "sha256-2TalLKDDoJdKGZHr7eNNvVW8fL7wQJjnZv34LJokfow=";
  };

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
