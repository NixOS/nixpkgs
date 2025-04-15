{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  hatchling,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-ly";
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = "python-ly";
    tag = "v${version}";
    hash = "sha256-CMMssU+qoHbhdny0sgpoYQas4ySPVHnu7GPnSthuMuE=";
  };

  build-system = [ hatchling ];

  # Tests seem to be broken ATM: https://github.com/wbsoft/python-ly/issues/70
  doCheck = false;

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/frescobaldi/python-ly/releases/tag/${src.tag}";
    description = "Tool and library for manipulating LilyPond files";
    homepage = "https://github.com/frescobaldi/python-ly";
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
