{ lib, buildPythonPackage, fetchFromGitHub, nose }:

buildPythonPackage rec {
  pname = "IPy";
  version = "1.01";

  src = fetchFromGitHub {
     owner = "autocracy";
     repo = "python-ipy";
     rev = "IPy-1.01";
     sha256 = "106rirmirlpb5ppznn3fd8189a8z02zf99jvk6j4hcq05ajclfc6";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -e fuzz
  '';

  meta = with lib; {
    description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
    homepage = "https://github.com/autocracy/python-ipy";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ y0no ];
  };
}
