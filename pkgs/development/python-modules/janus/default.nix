{ lib, buildPythonPackage, fetchPypi, pytest, pythonOlder }:

buildPythonPackage rec {
  pname = "janus";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0700f5537d076521851d19b7625545c5e76f6d5792ab17984f28230adcc3b34c";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Mixed sync-async queue";
    homepage = "https://github.com/aio-libs/janus";
    license = licenses.asl20;
    maintainers = [ maintainers.simonchatts ];
  };
}
