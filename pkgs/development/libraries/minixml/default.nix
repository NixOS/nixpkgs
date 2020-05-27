{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mxml";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "1kv36fxxh7bwfydhb90zjgsrvpyzvx1p5d0ayfvd3j8gip2rjhnp";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A small XML library";
    homepage = "https://www.msweet.org/mxml/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
