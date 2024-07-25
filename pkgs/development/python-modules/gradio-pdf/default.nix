{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-fancy-pypi-readme,
  hatch-requirements-txt,
  hatchling,
  gradio,
  gradio-client,
}:

buildPythonPackage rec {
  pname = "gradio-pdf";
  version = "0.0.11";
  format = "pyproject";

  src = fetchPypi {
    pname = "gradio_pdf";
    inherit version;
    hash = "sha256-HCfjJdd9DIRqm/dS00xlU9AYGM7U/b3zNo2IgZHtasc=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-requirements-txt
    hatchling
  ];

  dependencies = [ gradio-client ];

  buildInputs = [ gradio.sans-reverse-dependencies ];
  disallowedReferences = [ gradio.sans-reverse-dependencies ];

  pythonImportsCheck = [ "gradio_pdf" ];

  # tested in `gradio`
  doCheck = false;

  meta = with lib; {
    description = "Python library for easily interacting with trained machine learning models";
    homepage = "https://pypi.org/project/gradio-pdf/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
