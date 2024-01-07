{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, can
, cobs
, libpcap
, nunavut
, numpy
, pyserial
}:

buildPythonPackage rec {
  pname = "pycyphal";
  version = "1.15.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KVX+DwcJp1sjpcG1Utl9me1LwWDZPof+O6hoUt1xlXA=";
  };

  propagatedBuildInputs = [
    can
    cobs
    libpcap
    numpy
    nunavut
    pyserial
  ];

  # Can't seem to run the tests on nix
  doCheck = false;
  pythonImportsCheck = [
    "pycyphal"
  ];

  meta = with lib; {
    description = "A full-featured implementation of the Cyphal protocol stack in Python";
    longDescription = ''
      Cyphal is an open technology for real-time intravehicular distributed computing and communication based on modern networking standards (Ethernet, CAN FD, etc.).
    '';
    homepage = "https://opencyphal.org/";
    license = licenses.mit;
    maintainers = teams.ororatech.members;
  };
}
