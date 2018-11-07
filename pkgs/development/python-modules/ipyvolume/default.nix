{ stdenv
, buildPythonPackage
, fetchPypi
, pythreejs
, requests
, ipywebrtc
, pillow
, traitlets
, traittypes
, numpy
, ipywidgets
, pytest
}:

buildPythonPackage rec {
  pname = "ipyvolume";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2463e8d6eee296f45a651464042cd1e0b35a961c846726fc0c928ff44d374c61";
  };

  passthru = {
    jupyterlabExtensions = [ "ipyvolume" "jupyter-threejs" "@jupyter-widgets/jupyterlab-manager" ];
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ pythreejs requests ipywebrtc pillow traitlets traittypes numpy ipywidgets ];

  # tests require network
  doCheck = false;

  checkPhase = ''
    HOME=$(mktemp -d) pytest ipyvolume
  '';

  meta = with stdenv.lib; {
    description = "IPython widget for rendering 3d volumes";
    homepage = https://github.com/maartenbreddels/ipyvolume;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
