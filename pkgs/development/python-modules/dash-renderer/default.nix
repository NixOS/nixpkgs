{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash-renderer";
  version = "1.1.0";

  src = fetchPypi {
    inherit version;
    pname = "dash_renderer";
    sha256 = "eca9a3ee9604f349912aa7956cdce547378937d9e9491d3bf02f719cfea278e0";
  };

  doCheck = false; # no tests

  meta = with lib; {
    description = "Front-end component renderer for Dash";
    homepage = https://github.com/plotly/dash-renderer;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jdehaas ];
  };

}
