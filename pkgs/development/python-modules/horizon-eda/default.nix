{
  buildPythonPackage,
  fetchpatch,
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
    env
    ;

  pyproject = false;

  disabled = pythonOlder "3.9";

  patches = [
    # Replaces osmesa with EGL_PLATFORM_SURFACELESS_MESA
    (fetchpatch {
      url = "https://github.com/horizon-eda/horizon/commit/663a8adaa1cb7eae7a824de07df8909bc33677c3.patch";
      hash = "sha256-g0rP9NBDdDijh35Y2h4me9N5R/mjCn+2w7uhnv9bweY=";
    })
  ];

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
