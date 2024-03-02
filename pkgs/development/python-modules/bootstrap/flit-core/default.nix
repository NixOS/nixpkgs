{ lib
, stdenv
, python
, flit-core
}:

stdenv.mkDerivation {
  pname = "${python.libPrefix}-bootstrap-${flit-core.pname}";
  inherit (flit-core) version src patches meta;

  sourceRoot = "source/flit_core";

  buildPhase = ''
    runHook preBuild

    ${python.interpreter} -m flit_core.wheel

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${python.interpreter} bootstrap_install.py dist/flit_core-*.whl \
      --install-root "$out" --installdir "/${python.sitePackages}"

    runHook postInstall
  '';
}
