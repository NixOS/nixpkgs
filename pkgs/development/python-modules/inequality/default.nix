{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  libpysal,
  numpy,
  scipy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "inequality";
  version = "1.1.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "inequality";
    tag = "v${version}";
    hash = "sha256-tKMpmsP19K4dyBCj84FBoGkEvrmQuSi77sY3uQYvz5s=";
  };

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [
    libpysal
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "inequality" ];

  meta = {
    description = "Spatial inequality analysis";
    homepage = "https://github.com/pysal/inequality";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members;
  };
}
