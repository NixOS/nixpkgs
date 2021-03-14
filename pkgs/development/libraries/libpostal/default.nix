{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libpostal";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "openvenues";
    repo = "libpostal";
    rev = "v${version}";
    sha256 = "0qf5nkfkfjl2ylkrnw7kzax71y85gkr8i24glyp9rflyzmpj6giy";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--disable-data-download"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "--disable-sse2" ];

  meta = with lib; {
    description = "A C library for parsing/normalizing street addresses around the world. Powered by statistical NLP and open geo data";
    homepage = "https://github.com/openvenues/libpostal";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
