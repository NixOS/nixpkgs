{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "parsley";
  version = "1.3";
  src = fetchPypi {
    pname = "Parsley";
    inherit version;
    sha256 = "0hcd41bl07a8sx7nmx12p16xprnblc4phxkawwmmy78n8y6jfi4l";
  };
  # Tests fail although the package works just fine.  Unfortunately
  # the tests as run by the upstream CI server travis.org are broken.
  doCheck = false;
  meta = with lib; {
    license = licenses.mit;
    homepage = "https://launchpad.net/parsley";
    description = "Parser generator library based on OMeta, and other useful parsing tools";
    maintainers = with maintainers; [ seppeljordan ];
  };
}
