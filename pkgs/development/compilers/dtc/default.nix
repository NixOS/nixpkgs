{ stdenv
, lib
, fetchgit
, fetchpatch
, flex
, bison
, pkg-config
, which
, pythonSupport ? false
, python ? null
, swig
, libyaml
}:

stdenv.mkDerivation rec {
  pname = "dtc";
  version = "1.6.1";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-gx9LG3U9etWhPxm7Ox7rOu9X5272qGeHqZtOe68zFs4=";
  };

  patches = [
    # fix python 3.10 compatibility
    # based on without requiring the setup.py rework
    # https://git.kernel.org/pub/scm/utils/dtc/dtc.git/commit/?id=383e148b70a47ab15f97a19bb999d54f9c3e810f
    ./python-3.10.patch

    # fix dtc static building
    ./0001-Depend-on-.a-instead-of-.so-when-building-static.patch
  ];

  nativeBuildInputs = [ flex bison pkg-config which ]
    ++ lib.optionals pythonSupport [ python swig ];

  buildInputs = [ libyaml ];

  postPatch = ''
    patchShebangs pylibfdt/
  '';

  makeFlags = [ "PYTHON=python" "STATIC_BUILD=${toString stdenv.hostPlatform.isStatic}" ];
  installFlags = [ "INSTALL=install" "PREFIX=$(out)" "SETUP_PREFIX=$(out)" ];

  # Checks are broken on aarch64 darwin
  # https://github.com/NixOS/nixpkgs/pull/118700#issuecomment-885892436
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Device Tree Compiler";
    homepage = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    license = licenses.gpl2Plus; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
}
