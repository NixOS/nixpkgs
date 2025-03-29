{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatch-requirements-txt,
  hatchling,
  gradio,
  gradio-client,
}:

buildPythonPackage {
  pname = "gradio-pdf";
  version = "0.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freddyaboulton";
    repo = "gradio-pdf";
    # No source release on Pypi
    # No tags on GitHub
    rev = "8833e9cd419d2a5eeff98e3ae8cbe690913bcfce";
    hash = "sha256-z9rfVnH2qANDp2ukUGSogADbwqQQzCkB7Cp/04UtEpM=";
  };

  build-system = [
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

  meta = {
    description = "Python library for easily interacting with trained machine learning models";
    homepage = "https://pypi.org/project/gradio-pdf/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
