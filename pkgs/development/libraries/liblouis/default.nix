{ fetchFromGitHub
, stdenv
, autoreconfHook
, pkgconfig
, gettext
, python3
, texinfo
, help2man
, libyaml
, perl
}:

stdenv.mkDerivation rec {
  pname = "liblouis";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${version}";
    sha256 = "0v6w8b9r994mkkbm2gqgd7k5yfmdhgbabh0j1gmn375nyvhy4qqh";
  };

  outputs = [ "out" "dev" "man" "info" "doc" ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
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

  meta = with stdenv.lib; {
    description = "Open-source braille translator and back-translator";
    homepage = "http://liblouis.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
