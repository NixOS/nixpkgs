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
  version = "0.3.8";

  doCheck = false; # Tests require the pytest-astropy package

  src = fetchPypi {
    inherit pname version;
    sha256 = "800d9730c9e2bd299f14c29b4d709d1605c82833223a2e4f784fea7ad805c168";
  };

  propagatedBuildInputs = [ astropy requests keyring beautifulsoup4 html5lib ];

  meta = with pkgs.lib; {
    description = "Functions and classes to access online data resources";
    homepage = "https://astroquery.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
