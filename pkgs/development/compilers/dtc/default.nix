{ stdenv, fetchgit, flex, bison, pkgconfig, python2, swig, which }:

stdenv.mkDerivation rec {
  pname = "dtc";
  version = "1.5.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "075gj8bbahfdb8dlif3d2dpzjrkyf3bwbcmx96zpwhlgs0da8jxh";
  };

  nativeBuildInputs = [ flex bison pkgconfig swig which ];
  buildInputs = [ python2 ];

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
