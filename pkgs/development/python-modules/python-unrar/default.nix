{
  stdenv,
  lib,
  replaceVars,
  buildPythonPackage,
  fetchPypi,
  unrar,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "python-unrar";
  version = "0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "unrar";
    inherit version;
    hash = "sha256-skRHpbkwJL5gDvglVmi6I6MPRRF2V3tpFVnqE1n30WQ=";
  };

  build-system = [
    setuptools
  ];

  patches = [
    (replaceVars ./use_nix_unrar_path.patch {
      unrar_lib_path = "${unrar}/lib/libunrar${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = true;

  pythonImportsCheck = [ "unrar" ];

  meta = {
    homepage = "http://github.com/matiasb/python-unrar";
    changelog = "https://github.com/matiasb/python-unrar/releases/tag/v${version}";
    description = "Wrapper for UnRAR library, plus a rarfile module on top of it";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
    platforms = lib.platforms.linux;
  };
}
