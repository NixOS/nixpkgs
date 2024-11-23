{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  perl,
  cracklib,
  enablePAM ? stdenv.hostPlatform.isLinux,
  pam,
  enablePython ? false,
  python,
}:

# python binding generates a shared library which are unavailable with musl build
assert enablePython -> !stdenv.hostPlatform.isStatic;

stdenv.mkDerivation rec {
  pname = "libpwquality";
  version = "1.4.5";

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ] ++ lib.optionals enablePython [ "py" ];

  src = fetchFromGitHub {
    owner = "libpwquality";
    repo = "libpwquality";
    rev = "${pname}-${version}";
    sha256 = "sha256-YjvHzd4iEBvg+qHOVJ7/y9HqyeT+QDalNE/jdNM9BNs=";
  };

  patches =
    lib.optionals (!enablePython) [
      # this patch isn't useful but keeping it to avoid rebuilds on !enablePython
      # before 24.11 fully lands
      ./python-binding-prefix.patch
    ]
    ++ [
      # remove next release
      (fetchpatch {
        name = "musl.patch";
        url = "https://github.com/libpwquality/libpwquality/commit/b0fcd96954be89e8c318e5328dd27c40b401de96.patch";
        hash = "sha256-ykN1hcRKyX3QAqWTH54kUjOxN6+IwRpqQVsujTd9XWs=";
      })
    ]
    ++ lib.optionals enablePython [
      # remove next release
      (fetchpatch {
        name = "pr-74-use-setuptools-instead-of-distutils.patch";
        url = "https://github.com/libpwquality/libpwquality/commit/509b0a744adf533b524daaa65f25dda144a6ff40.patch";
        hash = "sha256-AxiynPVxv/gONujyj8y6b1XlsNkKszzW5TT9oINR/oo=";
      })
      # remove next release
      (fetchpatch {
        name = "pr-80-respect-pythonsitedir.patch";
        url = "https://github.com/libpwquality/libpwquality/commit/f92351b3998542e33d2b243fc446a4dd852dc972.patch";
        hash = "sha256-1lmigZX/UiEFe9b0JXmlfw/371UYT4PF7Ev2Hv66v74=";
      })
      # ensure python site-packages goes in $py output
      ./python-binding-root.patch
    ];

  nativeBuildInputs = [
    autoreconfHook
    perl
  ] ++ lib.optionals enablePython [ (python.withPackages (ps: with ps; [ setuptools ])) ];
  buildInputs = [ cracklib ] ++ lib.optionals enablePAM [ pam ];

  configureFlags =
    if enablePython then
      [
        "--enable-python-bindings=yes"
        "--with-pythonsitedir=\"${python.sitePackages}\""
      ]
    else
      # change to `--enable-python-bindings=no` in the future
      # leave for now to avoid rebuilds on !enablePython before 24.11 fully lands
      [ "--disable-python-bindings" ];

  meta = with lib; {
    homepage = "https://github.com/libpwquality/libpwquality";
    description = "Password quality checking and random password generation library";
    longDescription = ''
      The libpwquality library purpose is to provide common functions for
      password quality checking and also scoring them based on their apparent
      randomness. The library also provides a function for generating random
      passwords with good pronounceability. The library supports reading and
      parsing of a configuration file.

      In the package there are also very simple utilities that use the library
      function and PAM module that can be used instead of pam_cracklib. The
      module supports all the options of pam_cracklib.
    '';
    license = with licenses; [
      bsd3
      # or
      gpl2Plus
    ];
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
  };
}
