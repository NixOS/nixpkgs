{ pkgs
, buildPythonPackage
, fetchPypi
, astropy
, requests
, keyring
, beautifulsoup4
, html5lib
}:

buildPythonPackage rec {
  pname = "astroquery";
  version = "0.3.9";

  doCheck = false; # Tests require the pytest-astropy package

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zw3xp2rfc6h2v569iqsyvzhfnzp7bfjb7jrj61is1hrqw1cqjrb";
  };

  propagatedBuildInputs = [ astropy requests keyring beautifulsoup4 html5lib ];

  meta = with pkgs.lib; {
    description = "Functions and classes to access online data resources";
    homepage = "https://astroquery.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
