{ lib, fetchPypi, buildPythonPackage, six, pytest }:

buildPythonPackage rec {
  pname = "fake-useragent";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-V5xysYunkqW9VLpI5j5GTSGTPjNkcsl0CRpnV/Mb/Nw=";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Up to date simple useragent faker with real world database";
    homepage = "https://github.com/hellysmile/fake-useragent";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
