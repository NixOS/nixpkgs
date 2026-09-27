{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  libiio,
  scipy,
  plotly,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-html,
  hatchling,
  pytest,
  pyyaml,
  lxml,
  click,
  pytest-xdist,
}:

let
  pytest-libiio = buildPythonPackage (finalAttrs: {
    pname = "pytest-libiio";
    version = "0.2.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "tfcollins";
      repo = "pytest-libiio";
      rev = "v${finalAttrs.version}";
      hash = "sha256-3bCKDaKJXQIX+tbR5XHXhPAm+jc5UpYK0lZxv50kj5c=";
    };

    build-system = [ hatchling ];

    dependencies = [
      pytest
      libiio
      pyyaml
      lxml
      click
      pytest-xdist
    ];
  });
in

buildPythonPackage (finalAttrs: {
  pname = "adi";
  version = "0.0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "pyadi-iio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xYeCzQExnFvgxqD91L+Ncmo4XfXhK1hRlTGexNvvyp4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    libiio
  ];

  # required for test suite
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-html
    pytest-libiio
    scipy
    plotly
  ];

  pythonImportsCheck = [ "adi" ];

  meta = {
    description = "Analog Devices python interfaces for hardware with Industrial I/O drivers";
    homepage = "https://github.com/analogdevicesinc/pyadi-iio";
    # BSD-like license with restrictions on usage
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ feyorsh ];
  };
})
