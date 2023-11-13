{ lib
, stdenv
, python
, build
, flit-core
, installer
, packaging
, pyproject-hooks
, tomli
}:
let
  buildBootstrapPythonModule = basePackage: attrs: stdenv.mkDerivation ({
    pname = "${python.libPrefix}-bootstrap-${basePackage.pname}";
    inherit (basePackage) version src meta;

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
  } // attrs);

  bootstrap-packaging = buildBootstrapPythonModule packaging {};

  bootstrap-pyproject-hooks = buildBootstrapPythonModule pyproject-hooks {};

  bootstrap-tomli = buildBootstrapPythonModule tomli {};
in
buildBootstrapPythonModule build {
  propagatedBuildInputs = [
    bootstrap-packaging
    bootstrap-pyproject-hooks
  ] ++ lib.optionals (python.pythonOlder "3.11") [
    bootstrap-tomli
  ];
}
