# This function provides specific bits for building a setuptools-based Python package.

{ lib
, python
, bootstrapped-pip
}:

{
# passed to "python setup.py build_ext"
# https://github.com/pypa/pip/issues/881
  setupPyBuildFlags ? []
# Execute before shell hook
, preShellHook ? ""
# Execute after shell hook
, postShellHook ? ""
, ... } @ attrs:

let
  isCross = python.stdenv.buildPlatform != python.stdenv.hostPlatform;

  # use setuptools shim (so that setuptools is imported before distutils)
  # pip does the same thing: https://github.com/pypa/pip/pull/3265
  setuppy = ./run_setup.py;

  crossBuild = lib.optionalString isCross ''
    echo Cross building python extension
    export CROSS_COMPILE=${python.stdenv.cc.targetPrefix}
    export PYTHONXCPREFIX=${python}
    export CC="${python.stdenv.cc}/bin/${python.stdenv.cc.targetPrefix}cc"
    export LDSHARED="${python.stdenv.cc}/bin/${python.stdenv.cc.targetPrefix}cc -shared"
  '';


  abiName = abi: builtins.replaceStrings ["musl"] ["gnu"] abi;
  cpuName = cpu: if cpu.family == "arm"
                 then (if cpu.bits == 64 then "arm64" else "arm")
		 else cpu.name;

  pySuffix = platform: "${cpuName platform.parsed.cpu}-${platform.parsed.kernel.name}-${abiName platform.parsed.abi.name}";

  crossFixup = lib.optionalString isCross ''
    echo "Fixing python cross-compiled modules"
    build_so_suffix=${pySuffix python.stdenv.buildPlatform}
    host_so_suffix=${pySuffix python.stdenv.hostPlatform}

    for library in $( find "$out/lib" -name \*.so ); do
      echo "Fixing up $library"
      newName=$(echo $library | sed s/$build_so_suffix/$host_so_suffix/)
      basename=$(basename $library)
      newBaseName=$(basename $newName)

      if [ "$library" != "$newName" ]; then
        mv $library $newName

        for record in $( find "$out/lib" -name RECORD ); do
          substituteInPlace $record --replace $basename $newBaseName
        done
      fi
    done

    ${attrs.preFixup or ""}
  '';

  setupPython = python.nativePython.interpreter;

  crossIncludeDir = "${python}/include/python${python.majorVersion}";
  setupPyBuildFlagsComplete = lib.optional isCross "-I${crossIncludeDir}" ++setupPyBuildFlags;

  crossAttrs = if isCross then { preFixup =  crossFixup; catchConflicts = false; } else  {};
in attrs // crossAttrs // {
  # we copy nix_run_setup over so it's executed relative to the root of the source
  # many project make that assumption
  buildPhase = attrs.buildPhase or ''
    ${crossBuild}runHook preBuild
    cp ${setuppy} nix_run_setup
    ${setupPython} nix_run_setup ${lib.optionalString (setupPyBuildFlagsComplete != []) ("build_ext " + (lib.concatStringsSep " " setupPyBuildFlagsComplete))} bdist_wheel
    runHook postBuild
  '';

  installCheckPhase = attrs.checkPhase or ''
    runHook preCheck
    ${python.nativePython.interpreter} nix_run_setup test
    runHook postCheck
  '';

  # Python packages that are installed with setuptools
  # are typically distributed with tests.
  # With Python it's a common idiom to run the tests
  # after the software has been installed.
  doCheck = attrs.doCheck or true;

  shellHook = attrs.shellHook or ''
    ${preShellHook}
    if test -e setup.py; then
      tmp_path=$(mktemp -d)
      export PATH="$tmp_path/bin:$PATH"
      export PYTHONPATH="$tmp_path/${python.sitePackages}:$PYTHONPATH"
      mkdir -p $tmp_path/${python.sitePackages}
      ${python.nativePython.pkgs.bootstrapped-pip}/bin/pip install -e . --prefix $tmp_path >&2
    fi
    ${postShellHook}
  '';
}
