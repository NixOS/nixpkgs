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

stdenv.mkDerivation rec {
  pname = "liblouis";
  version = "3.22.0";

  outputs = [ "out" "dev" "man" "info" "doc" ];

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${version}";
    sha256 = "sha256-EI/uaHXe0NlqdEw764q0SjerThYEVLRogUlmrsZwXnY=";
  };

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
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
