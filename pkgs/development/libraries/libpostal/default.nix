{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libpostal";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "openvenues";
    repo = "libpostal";
    rev = "v${version}";
    sha256 = "sha256-gQTD2LQibaB2TK0SbzoILAljAGExURvDcF3C/TfDXqk=";
  };

  patches = [
    # Fix darwin compilation with XCode 12 https://github.com/openvenues/libpostal/issues/511
    (fetchpatch {
      name = "Fix-C-compilation-macOS.patch";
      url = "https://github.com/openvenues/libpostal/commit/9fcf066e38121b5c1439fc6bdc9a7e02234c8622.patch";
      hash = "sha256-VpboGK+5sc1XrxMB051KWc8vP7Eu2g7zmTirzSaerns=";
    })
    # https://github.com/openvenues/libpostal/commit/bfdb6b8f87cc1cae9ba47870ff23deae0bb8ba51.patch
    # with extra hunk removed so it applies
    ./0001-test-adding-header-to-fix-warning.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--disable-data-download"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "--disable-sse2" ];

  meta = with lib; {
    description = "A C library for parsing/normalizing street addresses around the world. Powered by statistical NLP and open geo data";
    homepage = "https://github.com/openvenues/libpostal";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    mainProgram = "libpostal_data";
    platforms = platforms.unix;
  };
}
