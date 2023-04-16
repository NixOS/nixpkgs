{ fetchFromGitHub
, fetchpatch
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

stdenv.mkDerivation rec {
  pname = "liblouis";
  version = "3.23.0";

  outputs = [ "out" "dev" "info" "doc" ]
    # configure: WARNING: cannot generate manual pages while cross compiling
    ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "man" ];

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${version}";
    sha256 = "sha256-jXNhHzydWaMhFbEKoFHyZ77GCvAqxyT3P0xIAgFlTzY=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-26767.patch";
      url = "https://github.com/liblouis/liblouis/commit/517f6f1f35fc5c57ac2f045caa168191bdeaadde.patch";
      excludes = [ "NEWS" ];
      sha256 = "sha256-qNFDHIEvSVIkZ3kjHYQtk7+KQ36TnBUJhxEZmZHapoA=";
    })
    (fetchpatch {
      name = "CVE-2023-26768.patch";
      url = "https://github.com/liblouis/liblouis/commit/21a2ee76d5de1ab3ce789ef18106343c8e65a175.patch";
      sha256 = "sha256-nFt56Mh9ZUxqcOgykgTaq0Va1nq5VWBuwU7O+Fq+dp0=";
    })
    (fetchpatch {
      name = "CVE-2023-26769.patch";
      url = "https://github.com/liblouis/liblouis/commit/b2e2995d1600e1d3b2131d4a2c5a57927d795608.patch";
      sha256 = "sha256-BSHexbFqed6RYodapEXwOEA0YmzJCByBsRsNJbeM5dY=";
    })
  ];

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
    # maketable.d
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
    homepage = "http://liblouis.org/";
    license = with licenses; [
      lgpl21Plus # library
      gpl3Plus # tools
    ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
