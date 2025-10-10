{
  buildPythonPackage,
  lib,
  fetchFromGitLab,
  writeTextFile,
  fetchurl,
  blas,
  lapack,
  mpi,
  fftw,
  scalapack,
  libxc,
  libvdwxc,
  which,
  ase,
  numpy,
  scipy,
  pyyaml,
  inetutils,
}:

assert lib.asserts.assertMsg (!blas.isILP64) "A 32 bit integer implementation of BLAS is required.";

assert lib.asserts.assertMsg (
  !lapack.isILP64
) "A 32 bit integer implementation of LAPACK is required.";

let
  gpawConfig = writeTextFile {
    name = "siteconfig.py";
    text = ''
      # Compiler
      compiler = 'gcc'
      mpicompiler = '${lib.getDev mpi}/bin/mpicc'
      mpilinker = '${lib.getDev mpi}/bin/mpicc'

      # BLAS
      libraries += ['blas']
      library_dirs += ['${lib.getLib blas}/lib']

      # FFTW
      fftw = True
      if fftw:
        libraries += ['fftw3']

      scalapack = True
      if scalapack:
        libraries += ['scalapack']

      # LibXC
      libxc = True
      if libxc:
        xc = '${libxc}/'
        include_dirs += ['${lib.getDev libxc}/include']
        library_dirs += ['${lib.getLib libxc}/lib']
        if 'xc' not in libraries:
          libraries.append('xc')

      # LibVDWXC
      libvdwxc = True
      if libvdwxc:
        vdwxc = '${libvdwxc}/'
        library_dirs += ['${lib.getLib libvdwxc}/lib']
        include_dirs += ['${lib.getDev libvdwxc}/include']
        libraries += ['vdwxc']
    '';
  };

  setupVersion = "24.11.0";
  pawDataSets = fetchurl {
    url = "https://wiki.fysik.dtu.dk/gpaw-files/gpaw-setups-${setupVersion}.tar.gz";
    hash = "sha256-lkyBzCj3+RpGhtPTGCxOvaMO+wnT+Wt/lerjFGSZwRA=";
  };
in
buildPythonPackage rec {
  pname = "gpaw";
  version = "25.1.0";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "gpaw";
    repo = "gpaw";
    rev = version;
    hash = "sha256-tdS383qT6hBr5hOqjoFS36nRSS2vdVkUR7sExwjWhng=";
  };

  # `inetutils` is required because importing `gpaw`, as part of
  # pythonImportsCheck, tries to execute its binary, which in turn tries to
  # execute `rsh` as a side-effect.
  nativeBuildInputs = [
    which
    inetutils
  ];

  buildInputs = [
    blas
    scalapack
    libxc
    libvdwxc
    fftw
  ];

  propagatedBuildInputs = [
    ase
    scipy
    numpy
    (lib.getBin mpi)
    pyyaml
  ];

  patches = [ ./SetupPath.patch ];

  postPatch = ''
    substituteInPlace gpaw/__init__.py \
      --subst-var-by gpawSetupPath "$out/share/gpaw/gpaw-setups-${setupVersion}"
  '';

  preConfigure = ''
    unset CC
    cp ${gpawConfig} siteconfig.py
  '';

  postInstall = ''
    currDir=$(pwd)
    mkdir -p $out/share/gpaw && cd $out/share/gpaw
    cp ${pawDataSets} gpaw-setups.tar.gz
    tar -xvf $out/share/gpaw/gpaw-setups.tar.gz
    rm gpaw-setups.tar.gz
    cd $currDir
  '';

  doCheck = false; # Requires MPI runtime to work in the sandbox
  pythonImportsCheck = [ "gpaw" ];

  passthru = {
    inherit mpi;
  };

  meta = with lib; {
    description = "Density functional theory and beyond within the projector-augmented wave method";
    homepage = "https://wiki.fysik.dtu.dk/gpaw/index.html";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.sheepforce ];
  };
}
