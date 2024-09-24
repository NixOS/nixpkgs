{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pcpp,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cxxheaderparser";
  version = "1.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotpy";
    repo = "cxxheaderparser";
    rev = version;
    hash = "sha256-Cyo+18mH1p5Zy4dWP3mjZRIkZZOyb61ABedk/amDi0g=";
  };

  postPatch = ''
    # version.py is generated based on latest git tag
    echo "__version__ = '${version}'" > cxxheaderparser/version.py
  '';

  build-system = [ setuptools ];

  checkInputs = [ pcpp ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "cxxheaderparser" ];

  meta = {
    description = "Modern pure python C++ header parser";
    homepage = "https://github.com/robotpy/cxxheaderparser";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
