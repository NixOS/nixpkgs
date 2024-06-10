{
  lib,
  stdenv,
  python,
  build,
  flit-core,
  installer,
  packaging,
  pyproject-hooks,
  tomli,
  makeWrapper,
}:
let
  buildBootstrapPythonModule =
    basePackage: attrs:
    stdenv.mkDerivation (
      {
        pname = "${python.libPrefix}-bootstrap-${basePackage.pname}";
        inherit (basePackage) version src meta;

        nativeBuildInputs = [ makeWrapper ];

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
      // attrs
    );

  bootstrap-packaging = buildBootstrapPythonModule packaging { };

  bootstrap-pyproject-hooks = buildBootstrapPythonModule pyproject-hooks { };

  bootstrap-tomli = buildBootstrapPythonModule tomli { };

  sitePkgs = python.sitePackages;
in
buildBootstrapPythonModule build {
  # like the installPhase above, but wrapping the pyproject-build command
  #   to set up PYTHONPATH with the correct dependencies.
  # This allows using `pyproject-build` without propagating its dependencies
  #   into the build environment, which is necessary to prevent
  #   pythonCatchConflicts from raising false positive alerts.
  # This would happen whenever the package to build has a dependency on
  #   another version of a package that is also a dependency of pyproject-build.
  installPhase = ''
    runHook preInstall

    PYTHONPATH="${installer}/${python.sitePackages}" \
      ${python.interpreter} -m installer \
        --destdir "$out" --prefix "" dist/*.whl

    wrapProgram $out/bin/pyproject-build \
      --prefix PYTHONPATH : "$out/${sitePkgs}" \
      --prefix PYTHONPATH : "${bootstrap-pyproject-hooks}/${sitePkgs}" \
      --prefix PYTHONPATH : "${bootstrap-packaging}/${sitePkgs}" \
      --prefix PYTHONPATH : "${bootstrap-tomli}/${sitePkgs}"

    runHook postInstall
  '';
}
