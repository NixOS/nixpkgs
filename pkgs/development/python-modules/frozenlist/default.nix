{
  lib,
  buildPythonPackage,
  cython,
  expandvars,
  fetchFromGitHub,
  pep517,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "frozenlist";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "frozenlist";
    tag = "v${version}";
    hash = "sha256-x2o4eiSDxA7nvrifzvV38kjIGmOY8gaQrPNDhCupovg=";
  };

  postPatch = ''
    rm pytest.ini
  '';

  nativeBuildInputs = [
    expandvars
    cython
    pep517
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    cython frozenlist/_frozenlist.pyx
  '';

  pythonImportsCheck = [ "frozenlist" ];

  meta = with lib; {
    description = "Python module for list-like structure";
    homepage = "https://github.com/aio-libs/frozenlist";
    changelog = "https://github.com/aio-libs/frozenlist/blob/v${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
