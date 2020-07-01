{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ck";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "concurrencykit";
    repo = pname;
    rev = version;
    sha256 = "1w7g0y1n7jslca693fb8sanlfi1biq956dw6avdx6pf3c2s7l9jd";
  };

  dontDisableStatic = true;

  meta = with stdenv.lib; {
    description = "High-performance concurrency research library";
    longDescription = ''
      Concurrency primitives, safe memory reclamation mechanisms and non-blocking data structures for the research, design and implementation of high performance concurrent systems.
    '';
    license = with licenses; [ asl20 bsd2 ];
    homepage = "http://concurrencykit.org/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ chessai ];
  };
}
