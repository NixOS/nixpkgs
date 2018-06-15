{ lib
, buildPythonPackage
, fetchPypi
, requests
, python
, fetchpatch
}:

buildPythonPackage rec {
  pname = "packet-python";
  version = "1.37.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "316941d2473c0f42ac17ac89e9aa63a023bb96f35cf8eafe9e091ea424892778";
  };
  propagatedBuildInputs = [ requests ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s test
  '';

  patches = [
    (fetchpatch {
      url = https://github.com/packethost/packet-python/commit/361ad0c60d0bfce2a992eefd17e917f9dcf36400.patch;
      sha256 = "1cmzyq0302y4cqmim6arnvn8n620qysq458g2w5aq4zj1vz1q9g1";
    })
  ];

  # Not all test files are included in archive
  doCheck = false;

  meta = {
    description = "A Python client for the Packet API.";
    homepage    = "https://github.com/packethost/packet-python";
    license     = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ dipinhora ];
  };
}