{ buildPythonPackage, cachetools, fetchFromGitHub, isPy27, lib }:

buildPythonPackage rec {
  pname = "CoAPthon3";
  version = "1.0.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "Tanganelli";
    repo = pname;
    rev = version;
    sha256 = "1im35i5i72y1p9qj8ixkwq7q6ksbrmi42giqiyfgjp1ym38snl69";
  };

  propagatedBuildInputs = [ cachetools ];

  # tests take in the order of 10 minutes to execute and sometimes hang forever on tear-down
  doCheck = false;
  pythonImportsCheck = [ "coapthon" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Python3 library to the CoAP protocol compliant with the RFC.";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
