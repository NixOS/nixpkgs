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
  version = "3.28.0";

  outputs = [ "out" "dev" "info" "doc" ]
    # configure: WARNING: cannot generate manual pages while cross compiling
    ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "man" ];

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PvGlhsnAxQctcODiK628BDdzYaWUIF/F3dN2g//Gywg=";
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
