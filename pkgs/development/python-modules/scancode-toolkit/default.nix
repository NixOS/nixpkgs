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
  pythonOlder,
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
  zipp,
}:

buildPythonPackage rec {
  pname = "scancode-toolkit";
  version = "32.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qZUILeB1lGv0V9Uq81/aOI9pJTtayfZH/O5kwNnpf28=";
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
  ]
  ++ lib.optionals (pythonOlder "3.9") [ zipp ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postInstall = ''
  '';

  pythonImportsCheck = [ "scancode" ];

  disabledTestPaths = [
    # Tests are outdated
    "src/formattedcode/output_spdx.py"
    "src/scancode/cli.py"
  ];

  # Takes a long time and doesn't appear to do anything
  dontStrip = true;

  meta = with lib; {
    description = "Tool to scan code for license, copyright, package and their documented dependencies and other interesting facts";
    homepage = "https://github.com/nexB/scancode-toolkit";
    changelog = "https://github.com/nexB/scancode-toolkit/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [
      asl20
      cc-by-40
    ];
    maintainers = [ ];
  };
}
