{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uc-micro-py,
  setuptools,
}:

buildPythonPackage rec {
  pname = "linkify-it-py";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = "linkify-it-py";
    tag = "v${version}";
    hash = "sha256-BLwIityUZDVdSbvTpLf6QUlZUavWzG/45Nfffn18/vU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ uc-micro-py ];

  pythonImportsCheck = [ "linkify_it" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Links recognition library with full unicode support";
    homepage = "https://github.com/tsutsu3/linkify-it-py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
