{ stdenv
, buildPythonPackage
, fetchFromGitHub
, html5lib
, six
, beautifulsoup4
, pkgs
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "infoqscraper";

  src = pkgs.fetchFromGitHub {
    owner = "cykl";
    repo = pname;
    rev = "v${version}";
    sha256 = "07mxp4mla7fwfc032f3mxrhjarnhkjqdxxibf9ba87c93z3dq8jj";
  };

  # requires network
  doCheck = false;

  buildInputs = [ html5lib ];
  propagatedBuildInputs = [ six beautifulsoup4 pkgs.ffmpeg pkgs.swftools pkgs.rtmpdump ];

  meta = with stdenv.lib; {
    description = "Discover presentations and/or create a movie consisting of slides and audio track from an infoq url";
    homepage = "https://github.com/cykl/infoqscraper/wiki";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo ];
  };

}
