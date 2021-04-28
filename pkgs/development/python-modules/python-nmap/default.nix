{ lib
, buildPythonPackage
, fetchPypi
, nmap
}:

buildPythonPackage rec {
  pname = "python-nmap";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "013q2797d9sf6mrj7x1hqfcql5gqgg50zgiifp2yypfa4k8cwjsx";
  };

  propagatedBuildInputs = [ nmap ];

  postPatch = ''
    substituteInPlace setup.cfg --replace "universal=3" "universal=1"
  '';

  # Tests requires sudo and performs scans
  doCheck = false;
  pythonImportsCheck = [ "nmap" ];

  meta = with lib; {
    description = "Python library which helps in using nmap";
    longDescription = ''
      python-nmap is a Python library which helps in using nmap port scanner. It
      allows to easily manipulate nmap scan results and will be a perfect tool
      for systems administrators who want to automatize scanning task and reports.
      It also supports nmap script outputs.
    '';
    homepage = "http://xael.org/pages/python-nmap-en.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
