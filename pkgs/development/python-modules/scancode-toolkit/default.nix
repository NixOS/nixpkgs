{
  lib,
  attrs,
  beautifulsoup4,
  bitarray,
  boolean-py,
  buildPythonPackage,
  chardet,
  click,
  colorama,
  commoncode,
  container-inspector,
  debian-inspector,
  dparse2,
  extractcode,
  extractcode-7z,
  extractcode-libarchive,
  fasteners,
  fetchPypi,
  fingerprints,
  ftfy,
  gemfileparser2,
  html5lib,
  importlib-metadata,
  intbitset,
  jaraco-functools,
  javaproperties,
  jinja2,
  jsonstreams,
  license-expression,
  lxml,
  markupsafe,
  multiregex,
  packageurl-python,
  packaging,
  parameter-expansion-patched,
  pefile,
  pip-requirements-parser,
  pkginfo2,
  pluggy,
  plugincode,
  publicsuffix2,
  pyahocorasick,
  pycryptodome,
  pygmars,
  pygments,
  pymaven-patch,
  pytestCheckHook,
  requests,
  saneyaml,
  setuptools,
  spdx-tools,
  text-unidecode,
  toml,
  typecode,
  typecode-libmagic,
  urlpy,
  writableTmpDirAsHomeHook,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "scancode-toolkit";
  version = "32.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "scancode_toolkit";
    inherit version;
    hash = "sha256-WXAZCk0aRmKb1UU1ud95mZFHAMC9U+gDRd9w7TZTVSA=";
  };

  dontConfigure = true;

  build-system = [ setuptools ];

  dependencies = [
    attrs
    beautifulsoup4
    bitarray
    boolean-py
    chardet
    click
    colorama
    commoncode
    container-inspector
    debian-inspector
    dparse2
    extractcode
    extractcode-7z
    extractcode-libarchive
    fasteners
    fingerprints
    ftfy
    gemfileparser2
    html5lib
    importlib-metadata
    intbitset
    jaraco-functools
    javaproperties
    jinja2
    jsonstreams
    license-expression
    lxml
    markupsafe
    multiregex
    packageurl-python
    packaging
    parameter-expansion-patched
    pefile
    pip-requirements-parser
    pkginfo2
    pluggy
    plugincode
    publicsuffix2
    pyahocorasick
    pycryptodome
    pygmars
    pygments
    pymaven-patch
    requests
    saneyaml
    spdx-tools
    text-unidecode
    toml
    typecode
    typecode-libmagic
    urlpy
    xmltodict
  ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Pre-genrating license index
  postInstall = ''
    $out/bin/scancode-reindex-licenses
  '';

  pythonImportsCheck = [ "scancode" ];

  # Takes a long time and doesn't appear to do anything
  dontStrip = true;

  meta = {
    description = "Tool to scan code for license, copyright, package and their documented dependencies and other interesting facts";
    homepage = "https://github.com/nexB/scancode-toolkit";
    changelog = "https://github.com/nexB/scancode-toolkit/blob/v${version}/CHANGELOG.rst";
    license = with lib.licenses; [
      asl20
      cc-by-40
    ];
    maintainers = [ ];
  };
}
