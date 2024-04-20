{ lib
, buildPythonPackage
, fetchPypi
, hatch-fancy-pypi-readme
, hatch-requirements-txt
, hatchling
, gradio
, gradio-client
}:

buildPythonPackage rec {
  pname = "gradio-pdf";
  version = "0.0.7";
  format = "pyproject";

  src = fetchPypi {
    pname = "gradio_pdf";
    inherit version;
    hash = "sha256-3OJiBnp79woCUtiNiaePwfJCAS42WYkv9GFeScesFv8=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-requirements-txt
    hatchling
  ];

  propagatedBuildInputs = [
    gradio-client
  ];

  buildInputs = [
    gradio.sans-reverse-dependencies
  ];
  disallowedReferences = [
    gradio.sans-reverse-dependencies
  ];

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
