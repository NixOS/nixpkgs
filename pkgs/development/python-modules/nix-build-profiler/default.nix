{ lib
, fetchFromGitHub
, buildPythonPackage
, psutil
, prefixed
, gnumake-tokenpool
, writeText
}:

buildPythonPackage rec {
  pname = "nix-build-profiler";
  version = "unstable-2022-07-09";

  src = fetchFromGitHub {
    owner = "milahu";
    repo = "nix-build-profiler";
    rev = "24559407783b46a20095813ba1d02ef4ad305089";
    sha256 = "Iv8TJCFOv7i0+or2ERpgDpEmFbE7Y99UE4ysfv+iGQU=";
  };

  propagatedBuildInputs = [
    psutil
    prefixed
    gnumake-tokenpool
  ];

  setupHook = writeText "setup-hook.sh" ''
    startNixBuildProfiler() {
      echo "Starting nix-build-profiler"
      nix-build-profiler &
    }
    prePhases+=" startNixBuildProfiler"
  '';

  meta = with lib; {
    description = "Profile CPU and memory usage of nix-build";
    longDescription = ''
      Usage:

      ```nix
      mkDerivation {
        nativeBuildInputs = [ nix-build-profiler ];
      }
      ```
    '';
    homepage = "https://github.com/milahu/nix-build-profiler";
    license = licenses.mit;
    maintainers = with maintainers; [ milahu ];
  };
}
