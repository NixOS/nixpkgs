{ stdenv, fetchFromGitHub, installShellFiles, cmake }:

stdenv.mkDerivation rec {
  pname = "doctest";
  version = "2.3.8";

  src = fetchFromGitHub {
    owner = "onqtam";
    repo = "doctest";
    rev = version;
    sha256 = "16w907750jnp98vdzkn72lzwy1zyryaqvfi80lbdp398pj23rq65";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/onqtam/doctest";
    description = "The fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
