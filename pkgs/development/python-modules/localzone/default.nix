{ stdenv
, buildPythonPackage
, fetchFromGitHub
, dnspython
, sphinx
, pytest
}:

buildPythonPackage rec {
  pname = "localzone";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "ags-slc";
    repo = pname;
    rev = "v${version}";
    sha256 = "154l7qglsm4jrhqddvlas8cgl9qm2z4dzihv05jmsyqjikcmfwk8";
  };

  propagatedBuildInputs = [ dnspython sphinx ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A simple DNS library for managing zone files";
    homepage = "https://localzone.iomaestro.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ flyfloh ];
  };
}
