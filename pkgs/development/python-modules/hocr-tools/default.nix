{ buildPythonPackage
, fetchFromGitHub
, lxml
, pillow
, reportlab
, stdenv
}:
buildPythonPackage rec {
  pname = "hocr-tools";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "tmbdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "14f9hkp7pr677085w8iidwd0la9cjzy3pyj3rdg9b03nz9pc0w6p";
  };

  # hocr-tools uses a test framework that requires internet access
  doCheck = false;

  propagatedBuildInputs = [ pillow lxml reportlab ];

  meta = with stdenv.lib; {
    description = "
Tools for manipulating and evaluating the hOCR format for representing multi-lingual OCR results by embedding them into HTML";
    homepage = https://github.com/tmbdev/hocr-tools;
    license = licenses.asl20;
    maintainers = [ maintainers.kiwi ];
  };
}
