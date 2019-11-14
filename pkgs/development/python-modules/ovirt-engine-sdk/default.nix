{ lib, buildPythonPackage, fetchPypi, pkgs }:

buildPythonPackage rec {
  pname = "ovirt-engine-sdk-python";
  version = "4.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hz7rcz7l391n8ixcwvqw3iq5bx26fk9l5c6xxymv036zm3r9pnh";
  };

  doCheck = false;

  buildInputs = with pkgs.python37Packages; [ 
    pycurl 
    six 
    enum34
    pkgs.libxml2
  ];

  prePatch = ''
    substituteInPlace setup.py --replace "/usr/include/libxml2" "${pkgs.libxml2.dev}/include/libxml2"
  '';

  meta = with lib; {
    homepage = https://github.com/oVirt/ovirt-engine-sdk/;
    description = "The oVirt Python-SDK is a software development kit for the oVirt engine API";
    license = licenses.asl20;
    maintainers = with maintainers; [ cptMikky ];
  };
}
