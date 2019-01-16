{ stdenv, fetchgit, fetchpatch, flex, bison, pkgconfig, python2, swig, which }:

stdenv.mkDerivation rec {
  name = "dtc-${version}";
  version = "1.4.7";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "0l787g1wmd4d6izsp91m5r2qms2h2jg2hhzllfi9qkbnplyz21wn";
  };

  nativeBuildInputs = [ flex bison pkgconfig swig which ];
  buildInputs = [ python2 ];

  patches = [
    # Fix setup.py
    (fetchpatch {
      url = "https://github.com/dezgeg/dtc/commit/d94a745148ba5c9198143ccc0f7d877fe498ab73.patch";
      sha256 = "0hpryx04j1swvmjisrfhvss08zzz4nxz9iv72lp4jdgg6vg0argl";
    })
  ];
  postPatch = ''
    patchShebangs pylibfdt/
  '';

  installFlags = [ "INSTALL=install" "PREFIX=$(out)" "SETUP_PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Device Tree Compiler";
    homepage = https://git.kernel.org/cgit/utils/dtc/dtc.git;
    license = licenses.gpl2; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
}
