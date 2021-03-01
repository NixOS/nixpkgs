{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "python-frontmatter";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "eyeseast";
    repo = pname;
    rev = "v${version}";
    sha256 = "1iki3rcbg7zs93m3mgqzncybqgdcch25qpwy84iz96qq8pipfs6g";
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
