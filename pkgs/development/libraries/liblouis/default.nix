{ fetchFromGitHub
, lib
, stdenv
, autoreconfHook
, pkg-config
, gettext
, python3
, texinfo
, help2man
, libyaml
, perl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblouis";
<<<<<<< HEAD
  version = "3.26.0";
=======
  version = "3.25.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" "info" "doc" ]
    # configure: WARNING: cannot generate manual pages while cross compiling
    ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "man" ];

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Kko9qBWdNiZ61Wbb7lUYoSNU1hhRUexPcU3pADv0UHo=";
=======
    hash = "sha256-On5PbBgvDAeD41oGb5EKBtKvi/VXnLsVrTMX7tcwnq4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    python3
    # Docs, man, info
    texinfo
    help2man
  ];

  buildInputs = [
    # lou_checkYaml
    libyaml
  ];

  nativeCheckInputs = [
    perl
  ];

  configureFlags = [
    # Required by Python bindings
    "--enable-ucs4"
  ];

  postPatch = ''
    patchShebangs tests
    substituteInPlace python/louis/__init__.py.in --replace "###LIBLOUIS_SONAME###" "$out/lib/liblouis.so"
  '';

  postInstall = ''
    pushd python
    python setup.py install --prefix="$out" --optimize=1
    popd
  '';

  doCheck = true;

  meta = with lib; {
    description = "Open-source braille translator and back-translator";
    homepage = "https://liblouis.io/";
    license = with licenses; [
      lgpl21Plus # library
      gpl3Plus # tools
    ];
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
})
