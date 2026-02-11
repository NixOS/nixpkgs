{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  webencodings,
  pytest-expect,
  pytestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "html5lib";
  version = "1.1-unstable-2024-02-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "html5lib";
    repo = "html5lib-python";
    rev = "fd4f032bc090d44fb11a84b352dad7cbee0a4745";
    hash = "sha256-Hyte1MEqlrD2enfunK1qtm3FJlUDqmhSyrCjo7VaBgA=";
  };

  patches = [
    # https://github.com/html5lib/html5lib-python/pull/583
    ./python314-compat.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    six
    webencodings
  ];

  nativeCheckInputs = [
    pytest-expect
    pytestCheckHook
  ];

  passthru.updateScript = unstableGitUpdater {
    branch = "master";
  };

  meta = {
    homepage = "https://github.com/html5lib/html5lib-python";
    downloadPage = "https://github.com/html5lib/html5lib-python/releases";
    description = "HTML parser based on WHAT-WG HTML5 specification";
    longDescription = ''
      html5lib is a pure-python library for parsing HTML. It is designed to
      conform to the WHATWG HTML specification, as is implemented by all
      major web browsers.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prikhi
    ];
  };
}
