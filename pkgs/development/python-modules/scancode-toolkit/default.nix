{ lib
, attrs
, beautifulsoup4
, bitarray
, boolean-py
, buildPythonPackage
, chardet
, click
, colorama
, commoncode
, container-inspector
, debian-inspector
, dparse2
, extractcode
, extractcode-7z
, extractcode-libarchive
, fasteners
, fetchPypi
, fingerprints
, ftfy
, gemfileparser2
, html5lib
, importlib-metadata
, intbitset
, jaraco-functools
, javaproperties
, jinja2
, jsonstreams
, license-expression
, lxml
, markupsafe
, packageurl-python
, packaging
, parameter-expansion-patched
, pefile
, pip-requirements-parser
, pkginfo2
, pluggy
, plugincode
, publicsuffix2
, pyahocorasick
, pycryptodome
, pygmars
, pygments
, pymaven-patch
, pytestCheckHook
, pythonOlder
, requests
, saneyaml
, setuptools
, spdx-tools
, text-unidecode
, toml
, typecode
, typecode-libmagic
, urlpy
, xmltodict
, zipp
}:

buildPythonPackage rec {
  pname = "scancode-toolkit";
  version = "32.0.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W6Ev1MV8cZU4bauAfmuZsBzMJKz7xpw8siO3Afn5mc8=";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
  ] ++ lib.optionals (pythonOlder "3.9") [
    zipp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Importing scancode needs a writeable home, and preCheck happens in between
  # pythonImportsCheckPhase and pytestCheckPhase.
  postInstall = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "scancode"
  ];

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
    license = with licenses; [ asl20 cc-by-40 ];
    maintainers = with maintainers; [ ];
  };
}
