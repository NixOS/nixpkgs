{ buildPythonPackage, fetchPypi, requests, lib }:

buildPythonPackage rec {
  pname = "cfscrape";
  version = "1.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fh97spqv69r0amcbjhhkl5nbjc2dmddsv91fw9lcbw7wrrc2zzs";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "A Python module to bypass Cloudflare's anti-bot page";
    license = licenses.mit;
    homepage = https://github.com/Anorov/cloudflare-scrape;
    maintainers = with maintainers; [ mredaelli ];
  };
}
