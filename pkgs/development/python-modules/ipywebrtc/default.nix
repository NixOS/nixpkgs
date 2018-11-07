{ stdenv
, buildPythonPackage
, fetchPypi
, ipywidgets
, pytest
}:

buildPythonPackage rec {
  pname = "ipywebrtc";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f43679b11ef3b3801fd0a81523d917f93ac1fcd5a52e5f5cf6031bf1d65774ca";
  };

  passthru = {
    jupyterlabExtensions = [ "jupyter-webrtc" ];
  };

  propagatedBuildInputs = [ ipywidgets ];

  # tests are disabled on release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "WebRTC for Jupyter notebook/lab";
    homepage = http://jupyter.org;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
