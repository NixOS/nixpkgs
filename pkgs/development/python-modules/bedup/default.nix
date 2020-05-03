{ stdenv
, buildPythonPackage
, fetchFromGitHub
, btrfs-progs
, contextlib2
, pyxdg
, pycparser
, alembic
, cffi
, pythonOlder
, isPyPy
}:

buildPythonPackage rec {
  version = "0.10.1";
  pname = "bedup";
  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "g2p";
    repo = "bedup";
    rev = "v${version}";
    sha256 = "0sp8pmjkxcqq0alianfp41mwq7qj10rk1qy31pjjp9kiph1rn0x6";
  };

  buildInputs = [ btrfs-progs ];
  propagatedBuildInputs = [ contextlib2 pyxdg pycparser alembic ]
    ++ stdenv.lib.optionals (!isPyPy) [ cffi ];

  meta = with stdenv.lib; {
    description = "Deduplication for Btrfs";
    longDescription = ''
      Deduplication for Btrfs. bedup looks for new and changed files,
      making sure that multiple copies of identical files share space
      on disk. It integrates deeply with btrfs so that scans are
      incremental and low-impact.
    '';
    homepage = "https://github.com/g2p/bedup";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 ];
  };
}
