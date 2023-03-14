{ lib, fetchFromGitHub, buildPythonPackage, pyyaml, six, pytest, pyaml }:

buildPythonPackage rec {
  pname = "python-frontmatter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "eyeseast";
    repo = pname;
    rev = "v${version}";
    sha256 = "0flyh2pb0z4lq66dmmsgyakvg11yhkp4dk7qnzanl34z7ikp97bx";
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
