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
    sha256 = "0vm1r1jlaiagj0l9yf7j6zn9w3733dr2169911c0svgrr3gwiwn9";
  };

  postPatch = ''
    substituteInPlace pasta/augment/inline_test.py \
      --replace-fail assertRaisesRegexp assertRaisesRegex
  '';

  propagatedBuildInputs = [ six ];

  meta = {
    description = "An AST-based Python refactoring library";
    homepage = "https://github.com/google/pasta";
    # Usually the tag message contains a one-line summary of the changes.
    changelog = "https://github.com/google/pasta/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timokau ];
  };
}
