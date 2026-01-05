{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  setuptools-scm,
  wheel,
  py,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-forked";
  version = "1.6.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-forked";
    tag = "v${version}";
    hash = "sha256-owkGwF5WQ17/CXwTsIYJ2AgktekRB4qhtsDxR0LCI/k=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/pytest-dev/pytest-forked/actions
      name = "pytest8-compat.patch";
      url = "https://github.com/pytest-dev/pytest-forked/commit/b2742322d39ebda97d5170922520f3bb9c73f614.patch";
      hash = "sha256-tTRW0p3tOotQMtjjJ6RUKdynsAnKRz0RAV8gAUHiNNA=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ py ];

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  disabledTests =
    if (pythonAtLeast "3.12" && stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) then
      [
        # non reproducible test failure on hydra, works on community builder
        # https://hydra.nixos.org/build/252537267
        "test_xfail"
      ]
    else
      null;

  setupHook = ./setup-hook.sh;

  meta = {
    changelog = "https://github.com/pytest-dev/pytest-forked/blob/${src.rev}/CHANGELOG.rst";
    description = "Run tests in isolated forked subprocesses";
    homepage = "https://github.com/pytest-dev/pytest-forked";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
