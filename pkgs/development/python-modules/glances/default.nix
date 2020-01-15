{ buildPythonPackage, fetchFromGitHub, isPyPy, lib
, psutil, setuptools, bottle, batinfo, pysnmp
, hddtemp, future
# Optional dependencies:
, netifaces # IP module
# Tests:
, unittest2
}:

buildPythonPackage rec {
  pname = "glances";
  version = "3.1.2";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "v${version}";
    sha256 = "1z9sq0chhm8m4gq98yfknxj408cj017h7j375blngjk2zvhw39qd";
  };

  # Some tests fail in the sandbox (they e.g. require access to /sys/class/power_supply):
  patches = lib.optional doCheck ./skip-failing-tests.patch;

  doCheck = true;
  checkInputs = [ unittest2 ];

  propagatedBuildInputs = [ psutil setuptools bottle batinfo pysnmp hddtemp future
    netifaces
  ];

  preConfigure = ''
    sed -i 's/data_files\.append((conf_path/data_files.append(("etc\/glances"/' setup.py;
  '';

  meta = with lib; {
    homepage = https://nicolargo.github.io/glances/;
    description = "Cross-platform curses-based monitoring tool";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ primeos koral ];
  };
}
