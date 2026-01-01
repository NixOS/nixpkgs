{
<<<<<<< HEAD
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pcpp,
  pytestCheckHook,
=======
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pcpp,
  pytestCheckHook,
  setuptools,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "cxxheaderparser";
<<<<<<< HEAD
  version = "1.6.2";
=======
  version = "1.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotpy";
    repo = "cxxheaderparser";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-AvSwt8ED+w1WlLwa8DPP9+zG8g5c8p51mvQx8ZfDMqk=";
=======
    rev = version;
    hash = "sha256-3nQCUb2sgF91ilREHj/fb8IoMTHjPoOFWGzkbssGqFY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    # version.py is generated based on latest git tag
    echo "__version__ = '${version}'" > cxxheaderparser/version.py
  '';

<<<<<<< HEAD
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
=======
  build-system = [ setuptools ];

  checkInputs = [ pcpp ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "cxxheaderparser" ];

  meta = {
    description = "Modern pure python C++ header parser";
    homepage = "https://github.com/robotpy/cxxheaderparser";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
