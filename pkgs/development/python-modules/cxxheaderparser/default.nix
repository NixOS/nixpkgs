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
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotpy";
    repo = "cxxheaderparser";
    rev = version;
    hash = "sha256-Gf7O1jFICLUcN0z4WYQmh7co2AxdzJY+tdXzu/AdG/g=";
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
    platforms = lib.platforms.unix;
  };
}
