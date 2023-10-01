{ lib
, buildPythonPackage
, fetchFromGitHub
, cython_3
, djvulibre
, docbook-xsl-ns
, glibcLocales
, html5lib
, libxml2
, libxml2Python
, libxslt
, lxml
, packaging
, pillow
, pkg-config
, pyicu
, python-djvulibre
, setuptools
, tesseract5
, unittestCheckHook
, wheel
, withCuneiform ? false, cuneiform
, withGocr ? false, gocr
, withOcrad ? false, ocrad
}:

buildPythonPackage rec {
  pname = "ocrodjvu";
  version = "0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FriedrichFroebel";
    repo = "ocrodjvu";
    rev = version;
    hash = "sha256-JqGTQ8QlQtmh37Z/ztPYGWsvLiacF+d+nvN0pcv9qNI=";
  };

  nativeBuildInputs = [
    cython_3
    djvulibre
    glibcLocales
    libxml2
    libxml2Python
    packaging
    pkg-config
    setuptools
    tesseract5
    wheel
  ] ++ lib.optionals withCuneiform cuneiform
    ++ lib.optionals withGocr gocr
    ++ lib.optionals withOcrad ocrad;

  propagatedBuildInputs = [
    lxml
    python-djvulibre
  ];

  buildInputs = [
    docbook-xsl-ns
    html5lib
    libxslt
    pillow
    pyicu
    tesseract5
  ] ++ lib.optionals withCuneiform cuneiform
    ++ lib.optionals withGocr gocr
    ++ lib.optionals withOcrad ocrad;

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "tests" "-v" ];

  meta = with lib; {
    description = "Wrapper for OCR systems that allows you to perform OCR on DjVu files";
    homepage = "https://github.com/FriedrichFroebel/ocrodjvu";
    changelog = "https://github.com/FriedrichFroebel/ocrodjvu/blob/${version}/doc/changelog";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dansbandit ];
  };
}
