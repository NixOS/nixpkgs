{ buildPythonPackage, fetchFromGitHub, isPyPy, lib
, psutil, setuptools, bottle, batinfo, pysnmp
, hddtemp
, unittest2
}:

buildPythonPackage rec {
  name = "glances-${version}";
  version = "3.1.0";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "v${version}";
    sha256 = "0zjpp017i8b8bijdaj85rya7rmdqh4g8vkb42q14q2sw6agxz3zi";
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
