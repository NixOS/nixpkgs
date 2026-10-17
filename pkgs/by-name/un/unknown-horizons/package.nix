{
  lib,
  fetchFromGitHub,
  python3Packages,
  gettext,
  intltool,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "unknown-horizons";
  # Last tagged release is from 2019 and predates the Python 3 fixes on master.
  version = "0-unstable-2026-09-30";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unknown-horizons";
    repo = "unknown-horizons";
    rev = "702203736ef3bcf1884a2256a11152b2f372366c";
    hash = "sha256-d7wDcvyUx6ybxqgJxOIhiAS5K37SOD+WaDWdF02xKZI=";
  };

  # Upstream bug, not a packaging workaround. Vendored rather than fetched:
  # the pull request is still open, so the commit behind it may be rebased or
  # garbage collected.
  patches = [
    # The atlases are generated without waiting, then never installed.
    # https://github.com/unknown-horizons/unknown-horizons/pull/2980
    ./atlas-generation.patch
  ];

  postPatch = ''
    # The launcher searches hardcoded FHS paths for its content dir.
    substituteInPlace run_uh.py \
      --replace-fail "'/app/share'," "'${placeholder "out"}/share', '/app/share',"

    # setup.py runs `git describe` for the version and falls back to this
    # file. Only the shape matters; it has to parse as PEP 440.
    echo -n "2019.1-0-g${builtins.substring 0 8 finalAttrs.src.rev}" > content/packages/gitversion.txt
  '';

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    gettext
    intltool
    # Atlas generation writes to $HOME.
    writableTmpDirAsHomeHook
  ];

  dependencies = with python3Packages; [
    distro
    fifengine
    pillow
    pyyaml
  ];

  # No test suite that runs without a display.
  doCheck = false;

  meta = {
    description = "2D realtime strategy simulation with an emphasis on economy and city building";
    homepage = "https://unknown-horizons.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "unknown-horizons";
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    platforms = lib.platforms.linux;
  };
})
