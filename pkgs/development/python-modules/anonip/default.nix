{ stdenv, lib, buildPythonPackage, fetchFromGitHub, ipaddress, isPy27 }:

buildPythonPackage rec {
  pname = "anonip";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "DigitaleGesellschaft";
    repo = "Anonip";
    rev = "v${version}";
    sha256 = "0y5xqivcinp6pwx4whc8ca1n2wxrvff7a2lpbz2dhivilfanmljs";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ ipaddress ];

  checkPhase = "python tests.py";

  meta = with stdenv.lib; {
    homepage = "https://github.com/DigitaleGesellschaft/Anonip";
    description = "A tool to anonymize IP-addresses in log-files";
    license = licenses.bsd3;
    maintainers = [ maintainers.mmahut ];
  };
}
