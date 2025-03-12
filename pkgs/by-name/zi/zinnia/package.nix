{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "zinnia";
  version = "2016-08-28";

  src = fetchFromGitHub {
    owner = "taku910";
    repo = "zinnia";
    rev = "fd74d8c8680bb3df8692279151ea6339ab68e32b";
    sha256 = "1izjy5qw6swg0rs2ym2i72zndb90mwrfbd1iv8xbpwckbm4899lg";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */zinnia)
  '';

  meta = with lib; {
    description = "Online hand recognition system with machine learning";
    homepage = "http://taku910.github.io/zinnia/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.gebner ];
  };
}
