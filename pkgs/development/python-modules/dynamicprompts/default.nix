{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, jinja2
, pyparsing
, pytest
, pytest-cov
, pytest-lazy-fixture
, requests
, transformers
}:

buildPythonPackage rec {
  pname = "dynamicprompts";
  version = "0.27.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lS/UgfZoR4wWozdtSAFBenIRljuPxnL8fMQT3dIA7WE=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    jinja2
    pyparsing
  ];

  passthru.optional-dependencies = {
    dev = [
      pytest
      pytest-cov
      pytest-lazy-fixture
    ];
    feelinglucky = [
      requests
    ];
    magicprompt = [
      transformers
    ];
  };

  pythonImportsCheck = [ "dynamicprompts" ];

  meta = with lib; {
    description = "Dynamic prompts templating library for Stable Diffusion";
    homepage = "https://pypi.org/project/dynamicprompts/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
