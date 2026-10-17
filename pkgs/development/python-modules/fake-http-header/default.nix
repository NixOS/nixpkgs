{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fake-http-header";
  version = "0.3.5-unstable-2025-07-09";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MichaelTatarski";
    repo = "fake-http-header";
    # https://github.com/MichaelTatarski/fake-http-header/issues/4
    rev = "0f110477d3ecae916e88608a123360227bfb6109";
    hash = "sha256-CznvDjzUeA0THsiIhuzvEDb4gXsP8IujpSCjt857qSo=";
  };
  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fake_http_header" ];

  meta = with lib; {
    description = "Generates random request fields for a http request header";
    homepage = "https://github.com/MichaelTatarski/fake-http-header";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
})
