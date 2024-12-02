{
  stdenv,
  lib,
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
  version = "2024.02";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devicetree-org";
    repo = "dt-schema";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-UJU8b9BzuuUSHRjnA6hOd1bMPNOlk4LNtrQV5aZmGhI=";
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

  meta = with lib; {
    description = "Tooling for devicetree validation using YAML and jsonschema";
    homepage = "https://github.com/devicetree-org/dt-schema/";
    changelog = "https://github.com/devicetree-org/dt-schema/releases/tag/v${version}";
    license = with licenses; [
      bsd2 # or
      gpl2Only
    ];
    maintainers = with maintainers; [ sorki ];

    broken = (
      # Library not loaded: @rpath/libfdt.1.dylib
      stdenv.hostPlatform.isDarwin
      ||

        # see https://github.com/devicetree-org/dt-schema/issues/108
        versionAtLeast jsonschema.version "4.18"
    );
  };
}
