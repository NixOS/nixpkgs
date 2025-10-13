{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-autorun,
  pytestCheckHook,
  runCommand,
}:

buildPythonPackage rec {
  pname = "auto-lazy-imports"; # matches pypi
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hmiladhia";
    repo = "lazyimports";
    tag = "v${version}";
    hash = "sha256-DPk/fupBuYmm7Xy5+qFkqeRoglflECuX8A0C2ncARhI=";
  };

  build-system = [
    hatchling
    hatch-autorun
  ];

  pythonImportsCheck = [
    "lazyimports"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preInstallCheck = ''
    if [[ -f "$out/${python.sitePackages}"/hatch_autorun_auto_lazy_imports.pth ]]; then
      echo >&2 "Found hatch_autorun_auto_lazy_imports.pth in site-packages"
    else
      echo >&2 "ERROR: no hatch_autorun_auto_lazy_imports.pth file found in site-packages, please re-check derivation assumptions"
      false
    fi
  '';

  preCheck = ''
    # Makes python load the .pth file in site-packages
    export NIX_PYTHONPATH="$out/${python.sitePackages}''${NIX_PYTHONPATH:+:"$NIX_PYTHONPATH"}"
  '';

  # check if NIX_PYTHONPATH is properly set in downstream environments
  passthru.tests = {
    check-autorun-pyenv =
      runCommand "${pname}-check-autorun-pyenv"
        {
          nativeBuildInputs = [
            (python.withPackages (ps: [
              ps.auto-lazy-imports
              ps.pytest
            ]))
          ];
        }
        ''
          pytest ${src}/tests && touch $out
        '';

    # TODO: this requires user to set NIX_PYTHONPATH
    # check-autorun-env =
    #   runCommand "${pname}-check-autorun-env"
    #     {
    #       nativeBuildInputs = [
    #         python
    #         python.pkgs.auto-lazy-imports
    #         python.pkgs.pytest
    #       ];
    #     }
    #     ''
    #       pytest ${src}/tests && touch $out
    #     '';
  };

  meta = {
    description = "Enable lazy imports using native python syntax";
    homepage = "https://github.com/hmiladhia/lazyimports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
