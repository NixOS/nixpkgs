{ lib, fetchFromGitHub, buildPythonPackage, pyyaml, six, pytest, pyaml }:

buildPythonPackage rec {
  pname = "python-frontmatter";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eyeseast";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-lkBCKZ1fZF580+4TnHYkfaGJjsWk7/Ksnk7VagZuef8=";
  };

  propagatedBuildInputs = [
    pyyaml
    pyaml # yes, it's needed
    six
  ];

  # tries to import test.test, which conflicts with module
  # exported by python interpreter
  doCheck = false;
  nativeCheckInputs = [
    pytest
  ];

  pythonImportsCheck = [ "frontmatter" ];

  meta = with lib; {
    homepage = "https://github.com/eyeseast/python-frontmatter";
    description = "Parse and manage posts with YAML (or other) frontmatter";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
