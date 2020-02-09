{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, isPyPy, lib
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
  patches = lib.optional (doCheck && stdenv.isLinux) ./skip-failing-tests.patch
    ++ [
      (fetchpatch {
        # Correct unitest
        url = "https://github.com/nicolargo/glances/commit/abf64ffde31113f5f46ef286703ff061fc57395f.patch";
        sha256 = "00krahqq89jvbgrqx2359cndmvq5maffhpj163z10s1n7q80kxp1";
      })

      (fetchpatch {
        # Fix IP plugin initialization issue
        url = "https://github.com/nicolargo/glances/commit/48cb5ef8053d823302e7e53490fb22cec2fabb0f.patch";
        sha256 = "1590qgcr8w3d9ddpgd9mk5j6q6aq29341vr8bi202yjwwiv2bia9";
      })
    ];

  # On Darwin this package segfaults due to mismatch of pure and impure
  # CoreFoundation. This issues was solved for binaries but for interpreted
  # scripts a workaround below is still required.
  # Relevant: https://github.com/NixOS/nixpkgs/issues/24693
  makeWrapperArgs = lib.optionals stdenv.isDarwin [
    "--set" "DYLD_FRAMEWORK_PATH" "/System/Library/Frameworks"
  ];

  doCheck = true;
  checkInputs = [ unittest2 ];
  preCheck = lib.optional stdenv.isDarwin ''
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
  '';

  propagatedBuildInputs = [ psutil setuptools bottle batinfo pysnmp future
    netifaces
  ] ++ lib.optional stdenv.isLinux hddtemp;

  preConfigure = ''
    sed -i 's/data_files\.append((conf_path/data_files.append(("etc\/glances"/' setup.py;
  '';

  meta = with lib; {
    homepage = https://nicolargo.github.io/glances/;
    description = "Cross-platform curses-based monitoring tool";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ primeos koral ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
