{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  pillow,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pypillowfight";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "OpenPaperwork";
    repo = "libpillowfight";
    tag = version;
    hash = "sha256-ZH1Eg8GLe3LZ7elohQCYCToEvx8bGaRSrcsT+qSY9s4=";
  };

  postPatch = ''
    echo '#define INTERNAL_PILLOWFIGHT_VERSION "${version}"' > src/pillowfight/_version.h
  '';

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    # Package has non-portable behavior that makes it not work on Darwin
    # https://github.com/NixOS/nixpkgs/pull/433141#issuecomment-3180885173
    broken = stdenv.hostPlatform.isDarwin;
    description = "Library containing various image processing algorithms";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
