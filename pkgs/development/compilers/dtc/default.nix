{ stdenv, lib, fetchgit, flex, bison, pkgconfig, which
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform, python2, swig
}:

stdenv.mkDerivation rec {
  pname = "dtc";
  version = "1.5.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "075gj8bbahfdb8dlif3d2dpzjrkyf3bwbcmx96zpwhlgs0da8jxh";
  };

  nativeBuildInputs = [ flex bison pkgconfig which ] ++ lib.optionals pythonSupport [ python2 swig ];
  buildInputs = lib.optionals pythonSupport [ python2 ];

  postPatch = ''
    patchShebangs pylibfdt/
  '';

  makeFlags = lib.optionals (!pythonSupport) [ "NO_PYTHON=1" ];
  installFlags = [ "INSTALL=install" "PREFIX=$(out)" "SETUP_PREFIX=$(out)" ];

  meta = with lib; {
    description = "Device Tree Compiler";
    homepage = https://git.kernel.org/cgit/utils/dtc/dtc.git;
    license = licenses.gpl2; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
}
