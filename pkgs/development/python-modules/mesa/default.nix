{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, fetchzip
, isPy27
, cookiecutter
, networkx
, pandas
, tornado
, tqdm
, pytest
}:

buildPythonPackage rec {
  pname = "mesa";
  version = "1.1.1";

  # According to their docs, this library is for Python 3+.
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "projectmesa";
    repo = "mesa";
    rev = "v${version}";
    hash = "sha256-6EVxhRRR0qmwsKlFeD/U89uolfNxgXd66doDDTxsvS4=";
  };

  postPatch =
    let
      bootstrap_version = "5.1.3";
      bootstrap = fetchzip {
        url = "https://github.com/twbs/bootstrap/releases/download/v${bootstrap_version}/bootstrap-${bootstrap_version}-dist.zip";
        hash = "sha256-eADXbCTyaVaFylZS86Ou/FwyhoqwHfJicpkyOfKfIG8=";
      };
      bootstrap_slider_version = "11.0.2";
      bootstrap_slider = fetchzip {
        url = "https://github.com/seiyria/bootstrap-slider/archive/refs/tags/v${bootstrap_slider_version}.zip";
        hash = "sha256-8ekuRfxbEABVch3FvpYKzH8EYS9sENs7kfApxyi2V2Q=";
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
    ''
      mkdir -p mesa/visualization/templates/{,js/}external
      cp -R ${bootstrap} mesa/visualization/templates/external/bootstrap-${bootstrap_version}-dist
      cp -R ${bootstrap_slider} mesa/visualization/templates/external/bootstrap-slider-${bootstrap_slider_version}
      cp ${d3} mesa/visualization/templates/js/external/d3-${d3_version}.min.js
      cp ${chartjs} mesa/visualization/templates/js/external/chart-${chartjs_version}.min.js
    '';

  checkInputs = [ pytest ];

  # Ignore test which tries to mkdir in unreachable location.
  checkPhase = ''
    pytest tests -k "not scaffold"
  '';

  propagatedBuildInputs = [ cookiecutter networkx pandas tornado tqdm ];

  meta = with lib; {
    homepage = "https://github.com/projectmesa/mesa";
    description = "An agent-based modeling (or ABM) framework in Python";
    license = licenses.asl20;
    maintainers = [ maintainers.dpaetzel ];
  };
}
