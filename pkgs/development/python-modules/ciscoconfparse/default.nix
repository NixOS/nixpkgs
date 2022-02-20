{ lib, buildPythonPackage, fetchFromGitHub, passlib, dnspython, loguru, toml
, ipaddr, poetry, poetry-core, black, Fabric, pytest, sphinx }:

buildPythonPackage rec {
  pname = "ciscoconfparse";
  version = "1.6.21";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mpenning";
    repo = pname;
    rev = version;
    sha256 = "1d6nzhmdg7zlg1h3lm4v7j4hsb2aqd475r5q5vcqxfdxszc92w21";
  };

  patchPhase = ''
    patchShebangs tests
  '';

  propagatedBuildInputs =
    [ passlib dnspython loguru toml ipaddr poetry black Fabric sphinx ];

  checkInputs = [ pytest ];

  meta = with lib; {
    description =
      "Parse, Audit, Query, Build, and Modify Cisco IOS-style configurations";
    homepage = "https://github.com/mpenning/ciscoconfparse";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.astro ];
  };
}
