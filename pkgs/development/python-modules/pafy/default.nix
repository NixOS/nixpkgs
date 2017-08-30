{ stdenv, buildPythonPackage, fetchFromGitHub, youtube-dl }:

buildPythonPackage rec {
  name = "pafy-${version}";
  version = "0.5.3.1-20170711";

  src = fetchFromGitHub {
    owner = "mps-youtube";
    repo = "pafy";
    rev = "7db06bd9e11eb80e4d3eb31528f8bd3de9360d2c";
    sha256 = "11d36h274cvwgncmmshr6p8mys8n3wg1jzb8z9r165sh3zrzxxh4";
  };

  propagatedBuildInputs = [ youtube-dl ];

  # No tests included in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library to download YouTube content and retrieve metadata";
    homepage = src.meta.homepage;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ odi ];
  };
}
