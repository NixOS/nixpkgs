{ buildPythonPackage, fetchFromGitHub, fetchpatch, isPyPy, lib
, psutil, setuptools, bottle, batinfo, pysnmp
, hddtemp, future
# Optional dependencies:
, netifaces # IP module
# Tests:
, unittest2
}:

buildPythonPackage rec {
  pname = "glances";
  version = "3.1.3";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "v${version}";
    sha256 = "15yz8sbw3k3n0729g2zcwsxc5iyhkyrhqza6fnipxxpsskwgqbwp";
  };

  # Some tests fail in the sandbox (they e.g. require access to /sys/class/power_supply):
  patches = lib.optional doCheck ./skip-failing-tests.patch
    ++ [ (fetchpatch {
      # Correct unitest
      url = "https://github.com/nicolargo/glances/commit/abf64ffde31113f5f46ef286703ff061fc57395f.patch";
      sha256 = "00krahqq89jvbgrqx2359cndmvq5maffhpj163z10s1n7q80kxp1";
    }) ];

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
