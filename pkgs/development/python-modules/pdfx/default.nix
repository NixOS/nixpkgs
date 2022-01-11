{ lib, buildPythonPackage, fetchFromGitHub, pdfminer, chardet, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pdfx";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "metachris";
    repo = "pdfx";
    rev = "v${version}";
    sha256 = "sha256-POpP6XwcqwvImrtIiDjpnHoNE0MKapuPjxojo+ocBK0=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "chardet==4.0.0" "chardet"
  '';

  propagatedBuildInputs = [ pdfminer chardet ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Extract references (pdf, url, doi, arxiv) and metadata from a PDF";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
