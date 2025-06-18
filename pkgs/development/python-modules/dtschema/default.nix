{
  stdenv,
  lib,
  nix-update-script,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pythonOlder,
  rfc3987,
  ruamel-yaml,
  setuptools-scm,
  libfdt,
}:

buildPythonPackage rec {
  pname = "dtschema";
  version = "2025.06.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devicetree-org";
    repo = "dt-schema";
    tag = "v${version}";
    hash = "sha256-OWpMBXwEX7QHA7ahM6m1NN/aY17lA0pANPaekJjRv1c=";
  };

  patches = [
    # Change name of pylibfdt to libfdt
    ./fix_libfdt_name.patch
  ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    jsonschema
    rfc3987
    ruamel-yaml
    libfdt
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "dtschema" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tooling for devicetree validation using YAML and jsonschema";
    homepage = "https://github.com/devicetree-org/dt-schema/";
    changelog = "https://github.com/devicetree-org/dt-schema/releases/tag/v${version}";
    license = with licenses; [
      bsd2 # or
      gpl2Only
    ];
    maintainers = with maintainers; [
      sorki
      dramforever
    ];

    broken = (
      # Library not loaded: @rpath/libfdt.1.dylib
      stdenv.hostPlatform.isDarwin
      ||

        # see https://github.com/devicetree-org/dt-schema/issues/108
        versionAtLeast jsonschema.version "4.18"
    );
  };
}
