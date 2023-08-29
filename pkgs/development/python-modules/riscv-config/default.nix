{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, lib
, cerberus
, pyyaml
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "riscv-config";
  version = "3.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-K7W6yyqy/2c4WHyOojuvw2P/v7bND5K6WFfTujkofBw=";
  };

  patches = [
    # Remove when updating to v3.8.0+
    (fetchpatch {
      name = "remove-dangling-pip-import.patch";
      url = "https://github.com/riscv-software-src/riscv-config/commit/f75e7e13fe600b71254b0391be015ec533d3c3ef.patch";
      hash = "sha256-oVRynBIJevq3UzlMDRh2rVuBJZoEwEYhDma3Bb/QV2E=";
    })
  ];

  propagatedBuildInputs = [ cerberus pyyaml ruamel-yaml ];

  meta = with lib; {
    homepage = "https://github.com/riscv/riscv-config";
    description = "RISC-V configuration validator";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
