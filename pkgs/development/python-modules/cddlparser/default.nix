{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # dependencies
  setuptools,
}:

buildPythonPackage rec {
  pname = "cddlparser";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tidoust";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-Hrf6u5HeCICffgPAOcbb1FhybEVhgre7EXzQZhS8D9o=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    homepage = "https://github.com/tidoust/cddlparser";
    downloadPage = "https://github.com/tidoust/cddlparser/releases";
    description = "Concise data definition language (RFC 8610) parser implementation in Python";
    longDescription = ''
      A CDDL parser in Python

      Concise data definition language (RFC 8610) parser implementation in Python.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hemera ];
  };
}
