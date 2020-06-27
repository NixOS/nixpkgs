{ stdenv, fetchFromGitHub, cmake, openssl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libsrt";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Haivision";
    repo = "srt";
    rev = "v${version}";
    sha256 = "01xaq44j95kbgqfl41pnybvqy0yq6wd4wdw88ckylzf0nzp977xz";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl ];
  outputs = [ "out" "dev" ];
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/Haivision/srt";
    description = "Video transport technology that optimizes streaming performance across unpredictable networks, such as the Internet.";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = [ maintainers.lukegb ];
  };

}
