{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  six,
}:

buildPythonPackage rec {
  pname = "mplleaflet";
  version = "0.0.5";
  format = "setuptools";

  propagatedBuildInputs = [
    jinja2
    six
  ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BJ4LkXl85bRihTOVE4Fh/tno38H0cj9ILrsHOaC70ok=";
  };

  meta = {
    description = "Convert Matplotlib plots into Leaflet web maps";
    homepage = "https://github.com/jwass/mplleaflet";
    license = with lib.licenses; [ bsd3 ];
  };
}
