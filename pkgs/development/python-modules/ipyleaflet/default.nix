{ stdenv
, buildPythonPackage
, fetchPypi
, xarray
, traittypes
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipyleaflet";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "379b04e937e655ef35b3d41b56a29d4c4969c6d514749201aa9ffea400bd090c";
  };

  passthru = {
    jupyterlabExtensions = [ "jupyter-leaflet" ];
  };

  propagatedBuildInputs = [ xarray traittypes ipywidgets ];

  postPatch = ''
    touch LICENSE

    sed -i "s/xarray>=0.10,<0.10.8/xarray/" setup.py
  '';

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Jupyter widget for dynamic Leaflet maps";
    homepage = https://github.com/jupyter-widgets/ipyleaflet;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
