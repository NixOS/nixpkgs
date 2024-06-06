{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "peppercorn";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ip4bfwcpwkq9hz2dai14k2cyabvwrnvcvrcmzxmqm04g8fnimwn";
  };

  meta = with lib; {
    description = "A library for converting a token stream into a data structure for use in web form posts";
    homepage = "https://docs.pylonsproject.org/projects/peppercorn/en/latest/";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.all;
  };
}
