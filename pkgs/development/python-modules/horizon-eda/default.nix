{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  horizon-eda,
  mesa,
  pycairo,
  python,
  pythonOlder,
}:

let
  base = horizon-eda.passthru.base;
in
buildPythonPackage {
  inherit (base)
    pname
    version
    src
    meta
    CASROOT
    ;

  pyproject = false;

  disabled = pythonOlder "3.9";

  buildInputs = base.buildInputs ++ [
    mesa
    mesa.osmesa
    python
  ];

  propagatedBuildInputs = [ pycairo ];

  nativeBuildInputs = base.nativeBuildInputs;

  buildFlags = [ "pymodule" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}
    cp build/horizon.so $out/${python.sitePackages}

    runHook postInstall
  '';

  enableParallelBuilding = true;
}
