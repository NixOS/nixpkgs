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
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "frozenlist";
    rev = "refs/tags/v${version}";
    hash = "sha256-ICPJKN6P9ezTiDVoEVBQvJlXqF7aHE6aXFx0jzntdEA=";
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
