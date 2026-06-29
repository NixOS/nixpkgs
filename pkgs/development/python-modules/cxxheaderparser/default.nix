{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pcpp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cxxheaderparser";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotpy";
    repo = "cxxheaderparser";
    tag = version;
    hash = "sha256-BWFo9egVDH1Yqs0me9IL+opOWZFlrtNoB1CkiMwcSr8=";
  };

  postPatch = ''
    # version.py is generated based on latest git tag
    echo "__version__ = '${version}'" > cxxheaderparser/version.py
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  checkInputs = [ pcpp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cxxheaderparser" ];

  meta = {
    description = "Modern pure Python C++ header parser";
    homepage = "https://github.com/robotpy/cxxheaderparser";
    changelog = "https://github.com/robotpy/cxxheaderparser/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
