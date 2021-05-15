{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, markupsafe
, click
, typecode
, gemfileparser
, pefile
, fingerprints
, spdx-tools
, fasteners
, pycryptodome
, urlpy
, dparse
, jaraco_functools
, pkginfo
, debian-inspector
, extractcode
, ftfy
, pyahocorasick
, colorama
, jsonstreams
, packageurl-python
, pymaven-patch
, nltk
, pygments
, bitarray
, jinja2
, javaproperties
, boolean-py
, license-expression
, extractcode-7z
, extractcode-libarchive
, typecode-libmagic
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "scancode-toolkit";
  version = "21.3.31";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e0301031a302dedbb4304a91249534f3d036f84a119170b8a9fe70bd57cff95";
  };

  dontConfigure = true;

  # https://github.com/nexB/scancode-toolkit/issues/2501
  # * dparse2 is a "Temp fork for Python 2 support", but pdfminer requires
  # Python 3, so it's "fine" to leave dparse2 unpackaged and use the "normal"
  # version
  # * ftfy was pinned for similar reasons (to support Python 2), but rather than
  # packaging an older version, I figured it would be better to remove the
  # erroneous (at least for our usage) version bound
  # * bitarray's version bound appears to be unnecessary for similar reasons
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "dparse2" "dparse" \
      --replace "ftfy <  5.0.0" "ftfy" \
      --replace "bitarray >= 0.8.1, < 1.0.0" "bitarray"
  '';

  propagatedBuildInputs = [
    markupsafe
    click
    typecode
    gemfileparser
    pefile
    fingerprints
    spdx-tools
    fasteners
    pycryptodome
    urlpy
    dparse
    jaraco_functools
    pkginfo
    debian-inspector
    extractcode
    ftfy
    pyahocorasick
    colorama
    jsonstreams
    packageurl-python
    pymaven-patch
    nltk
    pygments
    bitarray
    jinja2
    javaproperties
    boolean-py
    license-expression
    extractcode-7z
    extractcode-libarchive
    typecode-libmagic
  ];

  checkInputs = [
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

  # takes a long time and doesn't appear to do anything
  dontStrip = true;

  meta = with lib; {
    description = "A tool to scan code for license, copyright, package and their documented dependencies and other interesting facts";
    homepage = "https://github.com/nexB/scancode-toolkit";
    license = with licenses; [ asl20 cc-by-40 ];
    maintainers = teams.determinatesystems.members;
  };
}
