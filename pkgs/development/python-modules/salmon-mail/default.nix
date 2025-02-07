{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
  chardet,
  python-daemon,
  jinja2,
  click,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "salmon-mail";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moggers87";
    repo = "salmon";
    tag = version;
    hash = "sha256-ysBO/ridfy7YPoTsVwAxar9UvfM/qxrx2dp0EtDNLvE=";
  };

  nativeCheckInputs = [
    jinja2
    unittestCheckHook
  ];

  build-system = [ setuptools ];

  dependencies = [
    chardet
    click
    dnspython
    python-daemon
  ];

  pythonImportsCheck = [
    "salmon"
    "salmon.handlers"
  ];

  # Darwin tests fail without this. See:
  # https://github.com/NixOS/nixpkgs/pull/82166#discussion_r399909846
  __darwinAllowLocalNetworking = true;

  # The tests use salmon executable installed by salmon itself so we need to add
  # that to PATH
  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    homepage = "https://salmon-mail.readthedocs.org/";
    changelog = "https://github.com/moggers87/salmon/blob/${src.rev}/CHANGELOG.rst";
    description = "Pythonic mail application server";
    mainProgram = "salmon";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jluttine ];
  };
}
