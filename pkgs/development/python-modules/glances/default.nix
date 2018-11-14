{ buildPythonPackage, fetchFromGitHub, isPyPy, lib
, psutil, setuptools, bottle, batinfo, pysnmp
, hddtemp
, unittest2
}:

buildPythonPackage rec {
  name = "glances-${version}";
  version = "3.0.2";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "v${version}";
    sha256 = "1jkjblfk4gbr00j7lny7ajiizzqnp0p1yhzfi14074gwk38z0q14";
  };

  patches = lib.optional doCheck ./skip-failing-tests.patch;

  # Requires access to /sys/class/power_supply
  doCheck = true;

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ psutil setuptools bottle batinfo pysnmp hddtemp ];

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
