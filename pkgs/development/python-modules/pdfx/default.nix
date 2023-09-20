{ lib, buildPythonPackage, fetchFromGitHub, pdfminer-six, chardet, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pdfx";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "metachris";
    repo = "pdfx";
    rev = "v${version}";
    hash = "sha256-POpP6XwcqwvImrtIiDjpnHoNE0MKapuPjxojo+ocBK0=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "chardet==4.0.0" "chardet" \
      --replace "pdfminer.six==20201018" "pdfminer.six"
  '';

  propagatedBuildInputs = [ pdfminer-six chardet ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Extract references (pdf, url, doi, arxiv) and metadata from a PDF";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
