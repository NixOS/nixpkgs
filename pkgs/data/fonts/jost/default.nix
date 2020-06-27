{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "jost";
  version = "3.5";

  src = fetchzip {
    url = "https://github.com/indestructible-type/Jost/releases/download/${version}/Jost.zip";
    sha256 = "0qw8dlycrzy3vm4yhasbygv7b209wyzcv231zick6kv6r1n3bvwx";
  };

  meta = with lib; {
    homepage = "https://github.com/indestructible-type/Jost";
    description = "A sans serif font by Indestructible Type";
    license = licenses.ofl;
    maintainers = [ maintainers.ar1a ];
  };
}
