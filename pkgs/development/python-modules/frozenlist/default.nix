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
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "frozenlist";
    tag = "v${version}";
    hash = "sha256-aBHX/U1L2mcah80edJFY/iXsM05DVas7lJT8yVTjER8=";
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
    changelog = "https://github.com/aio-libs/frozenlist/blob/${src.tag}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
