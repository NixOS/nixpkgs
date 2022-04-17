{ buildPythonPackage
, datasette
, fetchPypi
, lib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "datasette-leaflet";
  version = "0.2.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g13jkd00qpbz8snlrydmrya759byba71rvxdyp95qsb60sfdm4g";
  };

  propagatedBuildInputs = [ datasette ];

  pythonImportsCheck = [ "datasette_leaflet" ];

  meta = with lib; {
    description = "A plugin for Datasette that bundles Leaflet.js";
    homepage = "https://datasette.io/plugins/datasette-leaflet";
    license = licenses.asl20;
    maintainers = [ maintainers.bspammer ];
  };
}
