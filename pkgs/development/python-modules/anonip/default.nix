{ lib, buildPythonPackage, fetchFromGitHub, ipaddress, isPy27 }:

buildPythonPackage rec {
  pname = "anonip";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "DigitaleGesellschaft";
    repo = "Anonip";
    rev = "v${version}";
    sha256 = "0cssdcridadjzichz1vv1ng7jwphqkn8ihh83hpz9mcjmxyb94qc";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ ipaddress ];

  checkPhase = "python tests.py";

  meta = with lib; {
    homepage = "https://github.com/DigitaleGesellschaft/Anonip";
    description = "A tool to anonymize IP-addresses in log-files";
    license = licenses.bsd3;
    maintainers = [ maintainers.mmahut ];
  };
}
