{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "bsdiff4";
  version = "1.2.1";

  src = fetchFromGitHub {
     owner = "ilanschnell";
     repo = "bsdiff4";
     rev = "1.2.1";
     sha256 = "0can34y5gmmi2c5bifyvj8a838gqdllpq1hdcb4h4d31r2q1gzgd";
  };

  checkPhase = ''
    mv bsdiff4 _bsdiff4
    python -c 'import bsdiff4; bsdiff4.test()'
  '';

  meta = with lib; {
    description = "binary diff and patch using the BSDIFF4-format";
    homepage = "https://github.com/ilanschnell/bsdiff4";
    license = licenses.bsdProtection;
    maintainers = with maintainers; [ ris ];
  };
}
