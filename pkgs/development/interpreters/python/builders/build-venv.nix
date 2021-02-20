# Function to build a `venv`.

{ stdenv
, lib
, pythonPackages
, symlinkJoin
, runCommand
}:

f:

let
  packages = lib.remove python (pythonPackages.requiredPythonModules (f pythonPackages));

  paths = lib.concatStringsSep " " (map (pkg: (lib.getOutput "wheel" pkg)) packages);

  wheelsEnv = runCommand "wheels-cache" { } ''
    mkdir -p $out/dist
    cd $out/dist
    for path in ${paths}; do
      echo $path
      if [ -d "$path/dist" ]; then
        for file in "$path/dist/*.whl"; do
          ln -s $file .
        done
      fi
    done
  '';

  python = pythonPackages.python;

  # Assume pname corresponds to the project name. This should be the case.
  names = lib.concatStringsSep " " (map (pkg: pkg.pname) packages);

in stdenv.mkDerivation {
  name = "${python.pname}-venv";

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    ${python.interpreter} -m venv $out
    export PATH="$out/bin:$PATH"
    pip install --find-links ${wheelsEnv}/dist --no-index ${names}
  '';

  passthru.wheels = wheelsEnv;

}
