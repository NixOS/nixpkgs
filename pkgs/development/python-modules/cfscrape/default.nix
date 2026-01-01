{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage {
  pname = "cfscrape";
  version = "2.1.1";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "Anorov";
    repo = "cloudflare-scrape";
    rev = "9692fe7ff3c17b76ddf0f4d50d3dba7d1791c9c6";
    hash = "sha256-uO8lBZonjk+mlFYoNSaz+GIN/W9yf8VL9OQ7MKfsMgI=";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Anorov/cloudflare-scrape";
    description = "Python module to bypass Cloudflare's anti-bot page";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://github.com/Anorov/cloudflare-scrape";
    description = "Python module to bypass Cloudflare's anti-bot page";
    license = licenses.mit;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
