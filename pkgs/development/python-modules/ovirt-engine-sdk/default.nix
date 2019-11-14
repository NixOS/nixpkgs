{ 
  lib,
  buildPythonPackage,
  fetchPypi,
  pycurl,
  six,
  libxml2Python
}:

buildPythonPackage rec {
  pname = "ovirt-engine-sdk-python";
  version = "4.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hz7rcz7l391n8ixcwvqw3iq5bx26fk9l5c6xxymv036zm3r9pnh";
  };

  doCheck = true;

  propagatedBuildInputs = [ 
    pycurl 
    six 
    libxml2Python
  ];

  prePatch = ''
    substituteInPlace setup.py --replace "/usr/include/libxml2" "${lib.getDev libxml2Python}/include/libxml2"
  '';

  meta = with lib; {
    homepage = https://github.com/oVirt/ovirt-engine-sdk/;
    description = "The oVirt Python-SDK is a software development kit for the oVirt engine API";
    license = licenses.asl20;
    maintainers = with maintainers; [ cptMikky ];
  };
}
