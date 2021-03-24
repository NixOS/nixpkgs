{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "python-frontmatter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "eyeseast";
    repo = pname;
    rev = "v${version}";
    sha256 = "0flyh2pb0z4lq66dmmsgyakvg11yhkp4dk7qnzanl34z7ikp97bx";
  };

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    six
  ];

  checkInputs = with python3Packages; [
    pytest
  ];

  meta = with lib; {
    homepage = "https://github.com/eyeseast/python-frontmatter";
    description = "Parse and manage posts with YAML (or other) frontmatter";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
}
