{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "ed25519-${version}";
  version = "1.4";

  src = fetchurl {
    url = "mirror://pypi/e/ed25519/${name}.tar.gz";
    sha256 = "0ahx1nkxa0xis3cw0h5c4fpgv8mq4znkq7kajly33lc3317bk499";
  };

  meta = with stdenv.lib; {
    description = "Ed25519 public-key signatures";
    homepage = "https://github.com/warner/python-ed25519";
    license = licenses.mit;
    maintainers = with maintainers; [ np ];
  };
}
