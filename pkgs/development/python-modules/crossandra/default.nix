{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  result,
  mypy,
}:

buildPythonPackage rec {
  pname = "crossandra";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "crossandra";
    tag = version;
    hash = "sha256-/JhrjXRH7Rs2bUil9HRneBC9wlVYEyfwivjzb+eyRv8=";
  };

  build-system = [
    setuptools
    mypy
  ];
  dependencies = [ result ];

  pythonImportsCheck = [ "crossandra" ];
  prePatch = ''
    # pythonRelaxDepsHook did not work
    substituteInPlace pyproject.toml \
      --replace-fail "result ~= 0.9.0" "result >= 0.9.0"
  '';

  meta = {
    changelog = "https://github.com/trag1c/crossandra/blob/${src.rev}/CHANGELOG.md";
    description = "Fast and simple enum/regex-based tokenizer with decent configurability";
    license = lib.licenses.mit;
    homepage = "https://trag1c.github.io/crossandra";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
