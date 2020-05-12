{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07nyajjc3209ha2nbvk43sh5bnslwb2hs9wn8q5dpfngsc96wr9g";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Renderer for the Dash framework";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
