{ stdenv, buildPythonPackage, fetchFromGitHub, pdfminer, chardet, pytest }:

buildPythonPackage rec {
  pname = "pdfx";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "metachris";
    repo = "pdfx";
    rev = "v${version}";
    sha256 = "1183k4h5qdf8y0imbir9ja3yzzsvdmqgbv3bi6dnkgr1wy2xfr0v";
  };

  # Remove after https://github.com/metachris/pdfx/pull/28
  prePatch = ''
    sed -i -e "s|pdfminer2|pdfminer.six|" setup.py
  '';

  propagatedBuildInputs = [ pdfminer chardet ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Extract references (pdf, url, doi, arxiv) and metadata from a PDF";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
