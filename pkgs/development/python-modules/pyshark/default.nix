{ lib, buildPythonPackage, fetchFromGitHub, py, lxml, pytestCheckHook, wireshark-cli }:

buildPythonPackage rec {
  pname = "pyshark";
  version = "0.4.2.11";

  src = fetchFromGitHub {
    owner = "KimiNewt";
    repo = pname;
    rev = "v${version}";
    sha256 = "07dkhkf85cplcj1h3k8mmqzsn4zdkxzr0zg3gvf8yc8p5g5azx9q";
  };

  propagatedBuildInputs = [
    py
    lxml
  ];

  preConfigure = ''
    cd src
  '';

  preCheck = ''
    cd ..
  '';

  checkInputs = [
    pytestCheckHook
    wireshark-cli
  ];

  meta = with lib; {
    description = "Python wrapper for tshark, allowing python packet parsing using wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
