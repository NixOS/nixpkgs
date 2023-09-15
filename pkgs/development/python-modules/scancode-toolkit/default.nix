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
, fetchpatch
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
, spdx-tools
, text-unidecode
, toml
, typecode
, typecode-libmagic
, typing
, urlpy
, xmltodict
, zipp
}:

buildPythonPackage rec {
  pname = "scancode-toolkit";
  version = "32.0.6";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-suqk7LOnZgSJGlaHq81LDOSCHZWdsJOUbma6MEpHxSM=";
  };

  dontConfigure = true;

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
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  patches = [
    (fetchpatch {
      name = "${pname}-allow-stable-spdx-tools.patch";
      url = "https://github.com/nexB/scancode-toolkit/commit/d89ab6584d3df6b7eb1d1394559e9d967d6db6ae.patch";
      includes = [ "src/*" ];
      hash = "sha256-AU3vJlOxmCy3yvkupVaAVxAKxJI3ymXEk+A5DWSkfOM=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pdfminer.six >= 20200101" "pdfminer.six" \
      --replace "pluggy >= 0.12.0, < 1.0" "pluggy" \
      --replace "pygmars >= 0.7.0" "pygmars" \
      --replace "license_expression >= 21.6.14" "license_expression" \
      --replace "intbitset >= 2.3.0,  < 3.0" "intbitset" \
      --replace "spdx_tools == 0.7.0a3" "spdx_tools"
  '';

  # Importing scancode needs a writeable home, and preCheck happens in between
  # pythonImportsCheckPhase and pytestCheckPhase.
  postInstall = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "scancode"
  ];

  # takes a long time and doesn't appear to do anything
  dontStrip = true;

  meta = with lib; {
    description = "Tool to scan code for license, copyright, package and their documented dependencies and other interesting facts";
    homepage = "https://github.com/nexB/scancode-toolkit";
    changelog = "https://github.com/nexB/scancode-toolkit/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [ asl20 cc-by-40 ];
    maintainers = with maintainers; [ ];
  };
}
