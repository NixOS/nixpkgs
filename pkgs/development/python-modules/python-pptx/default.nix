{ lib
, buildPythonPackage
, fetchPypi
, lxml
, xlsxwriter
, pillow
}:
buildPythonPackage rec {
  pname = "python-pptx";
  version = "0.6.21";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d5iiqviVY1ZbPHEgwKz+mv93XbDbNYBUTjv0hAwuN48=";
  };

  # postPatch = ''
  #   substituteInPlace setup.py \
  #     --replace "grpcio-tools>=1.47.0, <=1.48.0" "grpcio-tools>=1.47.0, <=1.52.0" \
  #     --replace "grpcio>=1.47.0,<=1.48.0" "grpcio>=1.47.0,<=1.53.0" \
  #     --replace "ujson>=2.0.0,<=5.4.0" "ujson>=2.0.0,<=5.7.0"
  #   '';

  propagatedBuildInputs = [
    lxml
    xlsxwriter
    pillow
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/scanny/python-pptx";
    description = "Create Open XML PowerPoint documents in Python";
    license = licenses.mit;
    maintainers = with maintainers; [happysalada];
  };
}
