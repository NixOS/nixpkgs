{ stdenv, lib, fetchgit, flex, bison, pkgconfig, which
, pythonSupport ? false, python, swig
}:

stdenv.mkDerivation rec {
  pname = "dtc";
  version = "1.6.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "0li992wwd7kgy71bikanqky49y4hq3p3vx35p2hvyxy1k0wfy7i8";
  };

  nativeBuildInputs = [ flex bison pkgconfig which ] ++ lib.optionals pythonSupport [ python swig ];

  postPatch = ''
    patchShebangs pylibfdt/
  '';

  makeFlags = [ "PYTHON=python" ];
  installFlags = [ "INSTALL=install" "PREFIX=$(out)" "SETUP_PREFIX=$(out)" ];

  meta = with lib; {
    description = "Device Tree Compiler";
    homepage = "https://git.kernel.org/cgit/utils/dtc/dtc.git";
    license = licenses.gpl2; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
}
