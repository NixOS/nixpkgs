{
  buildPythonPackage,
  fetchPypi,
  lib,
  # propagateBuildInputs
  typing-extensions,
  typing-inspect,
}: let
  attrs = {
    # NOTE: Kept in sync with xformers
    pname = "pyre-extensions";
    version = "0.0.29";

    src = fetchPypi {
      inherit (attrs) pname version;
      hash = "sha256-QRNgBwbEcwahVtzJxAX01FjFBb5DJplXHjV+8g4tXXc=";
    };

    propagatedBuildInputs = [
      typing-extensions
      typing-inspect
    ];

    pythonImportsCheck = [(lib.strings.replaceStrings ["-"] ["_"] attrs.pname)];

    meta = with lib; {
      description = "Type system extensions for use with the pyre type checker";
      homepage = "https://pyre-check.org";
      license = licenses.mit;
      maintainers = with maintainers; [connorbaker];
    };
  };
in
  buildPythonPackage attrs
