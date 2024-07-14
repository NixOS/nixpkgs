{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "google-pasta";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yfLI38j5bQ1YCCmZIHIb4wye7DfyOJ8okE9FRWXIoW4=";
  };

  postPatch = ''
    substituteInPlace pasta/augment/inline_test.py \
      --replace-fail assertRaisesRegexp assertRaisesRegex
  '';

  propagatedBuildInputs = [ six ];

  meta = {
    description = "AST-based Python refactoring library";
    homepage = "https://github.com/google/pasta";
    # Usually the tag message contains a one-line summary of the changes.
    changelog = "https://github.com/google/pasta/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timokau ];
  };
}
