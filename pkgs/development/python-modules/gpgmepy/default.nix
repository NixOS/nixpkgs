{
  lib,
  python,
  fetchFromGitHub,
  autoreconfHook,
  swig,
  gnupg,
  libgpg-error,
  gpgme2,
}:

python.pkgs.buildPythonPackage rec {
  pname = "gpgmepy";
  version = "2.0.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "gpg";
    repo = "gpgmepy";
    rev = "gpgmepy-${version}";
    hash = "sha256-HLbULAo5y1Ba1bweGrAjd/sJdNwEq8hyR8AMRCZwi0E=";
  };

  postPatch = ''
    # Use pip instead of setup.py to avoid installation of egg; see https://dev.gnupg.org/T6784
    substituteInPlace Makefile.am \
      --replace-fail '"$$(basename "$${PYTHON}")' \
                     '"${placeholder "out"}/python-${lib.versions.majorMinor python.version}' \
      --replace-fail 'setup.py \' \
                     '-m pip install --use-pep517 --no-deps --prefix=${placeholder "out"} . && : \'

    # Upstream uses git to determine the release commit
    substituteInPlace autogen.sh \
      --replace-fail 'tmp="-unknown"' 'tmp=""'

    # The build copies gpgme.h from the gpgme2 package, which is read-only
    # some other part in the build needs write access, whcih fails, unless
    # patched as follows:
    substituteInPlace setup.py.in \
      --replace-fail 'shutil.copy2(source_name, sink_name)' \
                     'shutil.copy2(source_name, sink_name); os.chmod(sink_name, 0o644)'
  '';

  configurePhase = ''
    ./configure --prefix=$out
  '';

  buildPhase = ''
    make COPY_FILES=
  '';

  installPhase = ''
    make install
  '';

  nativeBuildInputs = [
    autoreconfHook
    swig
    gnupg
    gpgme2
    libgpg-error
    python.pkgs.pip
  ];

  buildInputs = [
    gpgme2
    libgpg-error
  ];

  build-system = [
    python.pkgs.setuptools
  ];

  pythonImportsCheck = [
    "gpg"
  ];

  meta = {
    description = "Python bindings for GPGME";
    homepage = "https://gnupg.org/software/gpgme/index.html";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpgmepy.git;f=NEWS;hb=gpgmepy-${version}";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
    ];
    # maintainers = with lib.maintainers; [ ];
  };
}
