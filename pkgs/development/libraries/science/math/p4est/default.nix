{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, p4est-withMetis ? true, metis
, p4est-sc
}:

let
  inherit (p4est-sc) debugEnable mpiSupport;
  dbg = lib.optionalString debugEnable "-dbg";
  withMetis = p4est-withMetis;
in
stdenv.mkDerivation {
  pname = "p4est${dbg}";
  version = "unstable-2021-06-22";

  # fetch an untagged snapshot of the prev3-develop branch
  src = fetchFromGitHub {
    owner = "cburstedde";
    repo = "p4est";
    rev = "7423ac5f2b2b64490a7a92e5ddcbd251053c4dee";
    sha256 = "0vffnf48rzw6d0as4c3x1f31b4kapmdzr1hfj5rz5ngah72gqrph";
  };

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook pkg-config ];
  propagatedBuildInputs = [ p4est-sc ];
  buildInputs = lib.optional withMetis metis;
  inherit debugEnable mpiSupport withMetis;

  patches = [ ./p4est-metis.patch ];
  postPatch = ''
    sed -i -e "s:\(^\s*ACLOCAL_AMFLAGS.*\)\s@P4EST_SC_AMFLAGS@\s*$:\1 -I ${p4est-sc}/share/aclocal:" Makefile.am
  '';
  preAutoreconf = ''
    echo "2.8.0" > .tarball-version
  '';
  preConfigure = lib.optionalString mpiSupport ''
    unset CC
  '';

  configureFlags = p4est-sc.configureFlags
    ++ [ "--with-sc=${p4est-sc}" ]
    ++ lib.optional withMetis "--with-metis"
  ;

  inherit (p4est-sc) makeFlags dontDisableStatic enableParallelBuilding doCheck;

  meta = {
    branch = "prev3-develop";
    description = "Parallel AMR on Forests of Octrees";
    longDescription = ''
      The p4est software library provides algorithms for parallel AMR.
      AMR refers to Adaptive Mesh Refinement, a technique in scientific
      computing to cover the domain of a simulation with an adaptive mesh.
    '';
    homepage = "https://www.p4est.org/";
    downloadPage = "https://github.com/cburstedde/p4est.git";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.cburstedde ];
  };
}
