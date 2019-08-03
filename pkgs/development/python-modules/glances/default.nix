{ buildPythonPackage, fetchFromGitHub, isPyPy, lib
, psutil, setuptools, bottle, batinfo, pysnmp
, hddtemp, future
# Optional dependencies:
, netifaces # IP module
# Tests:
, unittest2
}:

buildPythonPackage rec {
  name = "glances-${version}";
  version = "3.1.1";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "v${version}";
    sha256 = "1x9gw7hzw3p8zki82wdf359yxj0ylfw2096a4y621kj0p4xqsr4q";
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
