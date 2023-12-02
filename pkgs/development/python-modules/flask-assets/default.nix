{ lib, buildPythonPackage, fetchPypi, flask, webassets, flask-script, nose }:

buildPythonPackage rec {
  pname = "flask-assets";
  version = "2.1.0";

  src = fetchPypi {
    pname = "Flask-Assets";
    inherit version;
    hash = "sha256-+E1lMv/lnJ/zUoheh0D/TaJcC8+s2AXwqAaBXkQ1SBM=";
  };

  patchPhase = ''
    substituteInPlace tests/test_integration.py --replace 'static_path=' 'static_url_path='
    substituteInPlace tests/test_integration.py --replace "static_folder = '/'" "static_folder = '/x'"
    substituteInPlace tests/test_integration.py --replace "'/foo'" "'/x/foo'"
  '';

  propagatedBuildInputs = [ flask webassets flask-script nose ];

  meta = with lib; {
    homepage = "https://github.com/miracle2k/flask-assets";
    description = "Asset management for Flask, to compress and merge CSS and Javascript files";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
