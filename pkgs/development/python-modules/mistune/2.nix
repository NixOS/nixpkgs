{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistune";
  version = "2.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-AkYRPLJJLbh1xr5Wl0p8iTMzvybNkokchfYxUc7gnTQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mistune" ];

  meta = {
    changelog = "https://github.com/lepture/mistune/blob/v${finalAttrs.version}/docs/changes.rst";
    description = "Sane Markdown parser with useful plugins and renderers";
    homepage = "https://github.com/lepture/mistune";
    knownVulnerabilities = [
      "GHSA-h7ww-273w-6cm8"
      "CVE-2026-44896"
      "CVE-2026-59926"
      "CVE-2026-33441"
      "CVE-2026-59924"
      "CVE-2026-33079"
      "CVE-2026-59923"
      "GHSA-jhcm-5rpf-j3wv"
      "CVE-2026-44708"
      "CVE-2026-44897"
      "CVE-2026-44898"
      "CVE-2026-44899"
      "GHSA-9jjx-3hq3-hx4j"
      "GHSA-xrpv-r66x-8p7j"
      "CVE-2026-59929"
      "GHSA-xmwc-wjpr-q378"
      "CVE-2026-59922"
      "CVE-2026-59925"
      "CVE-2026-59928"
      "GHSA-96vr-jm8v-g22j"
      "CVE-2026-59930"
      "CVE-2026-59927"
      "GHSA-3q64-rw38-243v"
      "CVE-2026-49851"
      "GHSA-x2gr-6qf2-fc9x"
      "GHSA-f32h-38gf-rg5r"
      "GHSA-jxhr-4j38-fpxg"
      "GHSA-8ppg-4vv7-9p53"
    ];
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
