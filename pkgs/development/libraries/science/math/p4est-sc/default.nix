{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, p4est-sc-debugEnable ? true, p4est-sc-mpiSupport ? true
, mpi, openssh, zlib
}:

let
  dbg = if debugEnable then "-dbg" else "";
  debugEnable = p4est-sc-debugEnable;
  mpiSupport = p4est-sc-mpiSupport;
  isOpenmpi = mpiSupport && mpi.pname == "openmpi";
in
stdenv.mkDerivation {
  pname = "p4est-sc${dbg}";
  version = "unstable-2021-06-14";

  # fetch an untagged snapshot of the prev3-develop branch
  src = fetchFromGitHub {
    owner = "cburstedde";
    repo = "libsc";
    rev = "1ae814e3fb1cc5456652e0d77550386842cb9bfb";
    sha256 = "14vm0b162jh8399pgpsikbwq4z5lkrw9vfzy3drqykw09n6nc53z";
  };

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook pkg-config ];
  propagatedNativeBuildInputs = lib.optional mpiSupport mpi
    ++ lib.optional isOpenmpi openssh
  ;
  propagatedBuildInputs = [ zlib ];
  inherit debugEnable mpiSupport;

  postPatch = ''
    echo "dist_scaclocal_DATA += config/sc_v4l2.m4" >> Makefile.am
  '';
  preConfigure = ''
    echo "2.8.0" > .tarball-version
    ${if mpiSupport then "unset CC" else ""}
  '';

  configureFlags = [ "--enable-pthread=-pthread" ]
    ++ lib.optional debugEnable "--enable-debug"
    ++ lib.optional mpiSupport "--enable-mpi"
  ;

  dontDisableStatic = true;
  enableParallelBuilding = true;
  makeFlags = [ "V=0" ];

  preCheck = ''
    export OMPI_MCA_rmaps_base_oversubscribe=1
    export HYDRA_IFACE=lo
  '';

  # disallow Darwin checks due to prototype incompatibility of qsort_r
  # to be fixed in a future version of the source code
  doCheck = !stdenv.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform;

  meta = {
    branch = "prev3-develop";
    description = "Support for parallel scientific applications";
    longDescription = ''
      The SC library provides support for parallel scientific applications.
      Its main purpose is to support the p4est software library, hence
      this package is called p4est-sc, but it works standalone, too.
    '';
    homepage = "https://www.p4est.org/";
    downloadPage = "https://github.com/cburstedde/libsc.git";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.cburstedde ];
  };
}
