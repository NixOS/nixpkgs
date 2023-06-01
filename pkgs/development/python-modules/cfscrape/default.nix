{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "cfscrape";
  version = "2.1.1";
  src = fetchFromGitHub ({
    owner = "Anorov";
    repo = "cloudflare-scrape";
    rev = "9692fe7ff3c17b76ddf0f4d50d3dba7d1791c9c6";
    hash = "sha256-uO8lBZonjk+mlFYoNSaz+GIN/W9yf8VL9OQ7MKfsMgI=";
  });

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Anorov/cloudflare-scrape";
    description = "A Python module to bypass Cloudflare's anti-bot page";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ WeebSorceress ];
  };
}
