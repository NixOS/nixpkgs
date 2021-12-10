{ lib, buildPythonPackage, fetchFromGitHub, python-dateutil, lxml }:

buildPythonPackage rec {
  pname = "feedgen";
  version = "0.9.0";

  src = fetchFromGitHub {
     owner = "lkiesow";
     repo = "python-feedgen";
     rev = "v0.9.0";
     sha256 = "1plfhxj44avkd3qx4gsv678dnckj1yr0r5ci5ivhsin09qymz8zf";
  };

  propagatedBuildInputs = [ python-dateutil lxml ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Python module to generate ATOM feeds, RSS feeds and Podcasts.";
    downloadPage = "https://github.com/lkiesow/python-feedgen/releases";
    homepage = "https://github.com/lkiesow/python-feedgen";
    license = with licenses; [ bsd2 lgpl3 ];
    maintainers = with maintainers; [ casey ];
  };
}
