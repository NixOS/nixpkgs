{ stdenv, fetchFromGitHub, cmake, git }:

stdenv.mkDerivation rec {
  name = "libcsptr-${version}";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "libcsptr";
    rev = "v${version}";
    sha256 = "0i1498h2i6zq3fn3zf3iw7glv6brn597165hnibgwccqa8sh3ich";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Smart pointer constructs for the (GNU) C programming language";
    homepage = https://github.com/Snaipe/libcsptr;
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ maintainers.fragamus ];
  };
}
