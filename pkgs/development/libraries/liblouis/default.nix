{ fetchFromGitHub
, lib
, stdenv
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
  version = "3.21.0";

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${version}";
    sha256 = "sha256-Hfn0dfXihtUfO3R+qJaetrPwupcIwblvi1DQdHCF1s8=";
  };

  patches = [
    (fetchpatch {
      name = "parenthesize-memcpy-calls-clang.patch";
      url = "https://github.com/liblouis/liblouis/commit/528f38938e9f539a251d9de92ad1c1b90401c4d0.patch";
      sha256 = "0hlhqsvd5wflg70bd7bmssnchk8znzbr93in0zpspzbyap6xz112";
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
