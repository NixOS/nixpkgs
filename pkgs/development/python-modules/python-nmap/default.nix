{
  lib,
  buildPythonPackage,
  fetchPypi,
  nmap,
}:

buildPythonPackage rec {
  pname = "python-nmap";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-91r2uR3Y47DDH4adsyFj9iraaGlF5bfCX4S8D3+tO2Q=";
  };

  propagatedBuildInputs = [ nmap ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "universal=3" "universal=1"
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
    homepage = "https://xael.org/pages/python-nmap-en.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
