{
  lib,
  python,
  fetchFromGitHub,
  autoreconfHook,
  swig,
  gnupg,
  libgpg-error,
  gpgme,
  stdenv,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpgmepy";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "gpg";
    repo = "gpgmepy";
    tag = "gpgmepy-${finalAttrs.version}";
    hash = "sha256-HLbULAo5y1Ba1bweGrAjd/sJdNwEq8hyR8AMRCZwi0E=";
  };

  postPatch = ''
    # Upstream uses git to determine the release commit, unfortunately
    # the build does not handle the default properly failing with:
    # Invalid version: '2.0.0-unknown'
    substituteInPlace autogen.sh \
      --replace-fail 'tmp="-unknown"' 'tmp=""'

    # The build copies gpgme.h from the gpgme2 package, which is read-only in nix.
    # For some odd reason the build wants write access to gpgme.h, which fails
    # unless patched as follows:
    substituteInPlace setup.py.in \
      --replace-fail 'shutil.copy2(source_name, sink_name)' \
                     'shutil.copy2(source_name, sink_name); os.chmod(sink_name, 0o644)'
  '';

  nativeBuildInputs = [
    autoreconfHook
    libgpg-error
    gnupg
    gpgme
    python.pkgs.setuptools
    swig
    writableTmpDirAsHomeHook
  ];

  makeFlags = [ "COPY_FILES=" ];

  buildInputs = [
    python
    gpgme
    libgpg-error
  ];

  pythonImportsCheck = [
    "gpg"
  ];

  meta = {
    description = "Python bindings for GPGME";
    homepage = "https://gnupg.org/software/gpgme/index.html";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpgmepy.git;f=NEWS;hb=gpgmepy-${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [ afh ];
  };
})
