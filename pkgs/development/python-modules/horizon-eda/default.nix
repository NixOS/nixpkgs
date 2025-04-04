{
  buildPythonPackage,
  horizon-eda,
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
    python
  ];

  propagatedBuildInputs = [ pycairo ];

  nativeBuildInputs = base.nativeBuildInputs;

  ninjaFlags = [ "horizon.so" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}
    cp horizon.so $out/${python.sitePackages}

    runHook postInstall
  '';

  enableParallelBuilding = true;
}
