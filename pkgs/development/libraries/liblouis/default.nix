{ fetchFromGitHub
, lib, stdenv
, fetchpatch
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
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${version}";
    sha256 = "sha256-vuD+afTOzldhfCRG5ghnWulNhip7BaTE7GfPhxXSMFw=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-26981.patch";
      url = "https://github.com/liblouis/liblouis/commit/73751be7a5617bfff4a735ae095203a2d3ec50ef.patch";
      sha256 = "sha256-PvGG62QHVslrClZP903AYCBof6jDzNe4L8eFU8X0vF4=";
    })
  ];

  outputs = [ "out" "dev" "man" "info" "doc" ];

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
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
