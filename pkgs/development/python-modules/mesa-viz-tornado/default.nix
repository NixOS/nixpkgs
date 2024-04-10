{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  pythonOlder,
  setuptools,
  tornado,
}:

let
  bootstrap_version = "5.1.3";
  bootstrap = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${bootstrap_version}/bootstrap-${bootstrap_version}-dist.zip";
    hash = "sha256-vewp21DsjR7My3AgIrgj3wozPhBYFMJksyG9UYuJxyE=";
  };
  bootstrap_slider_version = "11.0.2";
  bootstrap_slider = fetchurl {
    url = "https://github.com/seiyria/bootstrap-slider/archive/refs/tags/v${bootstrap_slider_version}.zip";
    hash = "sha256-EDoKX3SsPBiE1bi9Nc/Y/7tTNwBDMM2G9SoPkak3ddU=";
  };
  d3_version = "7.4.3";
  d3 = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/d3/${d3_version}/d3.min.js";
    hash = "sha256-+MpQAOeqA18DtHk7JETZadE17KoMl0jCS89tlo6OWGM=";
  };
  chartjs_version = "3.6.1";
  chartjs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/chart.js@${chartjs_version}/dist/chart.min.js";
    hash = "sha256-bj8JMRF/ShthPyTNKaHVG4LwnGL/KNnJ5CAASgZE99I=";
  };
in
buildPythonPackage rec {
  pname = "mesa-viz-tornado";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "projectmesa";
    repo = "mesa-viz-tornado";
    rev = "v${version}";
    hash = "sha256-4KgHq2lm7o/Kv0vr1y2QvQ1erKZ4eEgo3quPU+GSQYk=";
  };

  postPatch = ''
    sed -i "/urlretrieve/d" setup.py
    cp ${bootstrap} bootstrap-${bootstrap_version}-dist.zip
    cp ${bootstrap_slider} bootstrap-slider-${bootstrap_slider_version}.zip
    cp ${d3} d3-${d3_version}.min.js
    cp ${chartjs} chart-${chartjs_version}.min.js
  '';

  build-system = [ setuptools ];

  dependencies = [ tornado ];

  pythonImportsCheck = [
    "mesa_viz_tornado.ModularVisualization"
    "mesa_viz_tornado.modules"
    "mesa_viz_tornado.UserParam"
    "mesa_viz_tornado.TextVisualization"
  ];

  meta = {
    changelog = "https://github.com/projectmesa/mesa-viz-tornado/releases/tag/v${version}";
    description = "Tornado-based visualization framework for Mesa";
    homepage = "https://github.com/projectmesa/mesa-viz-tornado";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
