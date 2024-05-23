{
  lib,
  stdenv,
  python,
  flit-core,
  installer,
}:

stdenv.mkDerivation {
  pname = "${python.libPrefix}-bootstrap-${installer.pname}";
  inherit (installer)
    version
    src
    patches
    meta
    ;

  buildPhase = ''
    runHook preBuild

    PYTHONPATH="${flit-core}/${python.sitePackages}" \
      ${python.interpreter} -m flit_core.wheel

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    PYTHONPATH=src ${python.interpreter} -m installer \
      --destdir "$out" --prefix "" dist/installer-*.whl

    runHook postInstall
  '';
}
