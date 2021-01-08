{ stdenv
, python
#, buildBuildHook
, pipInstallHook
, build
, wheel
, pip # Should be replaced by `installer`
, requiredPythonModules
, unzip
, setuptools
, flit-core
, wrapPython
}:

let
  runtimeDeps = requiredPythonModules [ build wheel ];
  srcs = with stdenv.lib; remove python.src (catAttrs "src" runtimeDeps);
in stdenv.mkDerivation rec {
  pname = "build";
  inherit (build) version;
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  inherit srcs;
  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    wrapPython
    pip # Replace with `installer`
    # Should collect the build backends
    setuptools
    python
    wheel
    flit-core

  ];

  buildInputs = [
    python
  ];

  propagatedBuildInputs = [
    #(buildInstallHook.override({build=null;}))
    #pipInstallHook
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    export PYTHONPATH="$(ls | tr '\n' '\:'):''${PYTHONPATH:-}"
    for pkg in $(find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \;); do
        pushd $pkg
        ${pip}/bin/pip install --no-build-isolation --no-index --prefix=$out  --ignore-installed --no-dependencies --no-cache .
        popd
    done

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonPrograms
  '';
}
