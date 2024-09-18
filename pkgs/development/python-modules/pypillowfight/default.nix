{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pillow,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pypillowfight";
  version = "0.3.0-unstable-2024-07-07";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "OpenPaperwork";
    repo = "libpillowfight";
    # Currently no tagged release past 0.3.0 and we need these patches to fix Python 3.12 compat
    rev = "4d5f739b725530cd61e709071d31e9f707c64bd6";
    hash = "sha256-o5FzUSDq0lwkXGXRMsS5NB/Mp4Ie833wkxKPziR23f4=";
  };

  prePatch = ''
    echo '#define INTERNAL_PILLOWFIGHT_VERSION "${version}"' > src/pillowfight/_version.h
  '';

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library containing various image processing algorithms";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
