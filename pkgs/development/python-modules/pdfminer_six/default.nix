{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, cryptography, chardet, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20220319";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "sha256-sjO7jmHSe4EDmJ1rfiXx+lsHxc+DfKeMet37Nbg03WQ=";
  };

  propagatedBuildInputs = [ chardet cryptography ];

  postInstall = ''
    for file in $out/bin/*.py; do
      ln $file ''${file//.py/}
    done
  '';

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "PDF parser and analyzer";
    homepage = "https://github.com/pdfminer/pdfminer.six";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy marsam ];
  };
}
