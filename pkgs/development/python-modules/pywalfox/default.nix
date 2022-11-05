{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pywalfox";
  version = "2.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Wec9fic4lXT7gBY04D2EcfCb/gYoZcrYA/aMRWaA7WY=";
  };

  patches = [
    ./no-modules.patch

    # Removes calls to change file permissions that are already set properly when
    # appearing in the Nix store, thereby preventing some warning messages.
    ./no-chmod.patch
  ];

  meta = with lib; {
    description = "Pywalfox - Native messaging host";
    homepage = "https://github.com/Frewacom/pywalfox";
    license = licenses.mpl20;
    maintainers = with maintainers; [ gekoke ];
  };
}
