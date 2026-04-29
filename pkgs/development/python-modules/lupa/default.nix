{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

}:
buildPythonPackage (finalAttrs: {
  pname = "lupa";
  version = "2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scoder";
    repo = "lupa";
    tag = "lupa-${finalAttrs.version}";
    # Lua sources are vendored as submodules under third-party/.
    # They are needed so that setup.py builds properly named backend
    # modules (e.g. lua51, lua54, luajit21) expected by consumers like fakeredis.
    fetchSubmodules = true;
    hash = "sha256-XLBUQ1TrzWWST9RJdMTnpsceldDNzidnL82bixLhSRA=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "lupa" ];

  meta = {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
