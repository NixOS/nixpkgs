{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycotap";
<<<<<<< HEAD
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z0NV8BMAvgPff4cXhOSYZSwtiawZzXfujmFlJjSi+Do=";
=======
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Tjs1JMczRnZWY+2M9Xqu3k48IuEcXMV5SUmqmJ3yew=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Test runner for unittest that outputs TAP results to stdout";
    homepage = "https://el-tramo.be/pycotap";
    license = licenses.mit;
    maintainers = with maintainers; [ mwolfe ];
  };
}
