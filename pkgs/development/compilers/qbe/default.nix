{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "qbe";
  version = "unstable-2019-07-11";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "7bf08ff50729037c8820b26d085905175b5593c8";
    sha256 = "0w1yack5ky6x6lbw8vn6swsy8s90n6ny0jpkw0866ja677z7qz34";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  meta = with stdenv.lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}

