{ stdenv
, python
, flit-core
, installer
, packaging
}:

stdenv.mkDerivation {
  pname = "${python.libPrefix}-bootstrap-${packaging.pname}";
  inherit (packaging) version src meta;

  buildPhase = ''
    runHook preBuild

    PYTHONPATH="${flit-core}/${python.sitePackages}" \
      ${python.interpreter} -m flit_core.wheel

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    PYTHONPATH="${installer}/${python.sitePackages}" \
      ${python.interpreter} -m installer \
        --destdir "$out" --prefix "" dist/*.whl

    runHook postInstall
  '';
}
