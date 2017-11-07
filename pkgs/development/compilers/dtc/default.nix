{ stdenv, fetchgit, fetchpatch, flex, bison, pkgconfig, python2, swig, which }:

stdenv.mkDerivation rec {
  name = "dtc-${version}";
  version = "1.4.5";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "10y5pbkcj5gkijcgnlvrh6q2prpnvsgihb9asz3zfp66mcjwzsy3";
  };

  nativeBuildInputs = [ flex bison pkgconfig swig which ];
  buildInputs = [ python2 ];

  patches = [
    # Fix 32-bit build
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git/patch/?id=497432fd2131967f349e69dc5d259072151cc4b4";
      sha256 = "1hrvhvz0qkck53mhacrc4rxjrvp34d8dkw7xb5lr4gpg32grvkpq";
    })
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
