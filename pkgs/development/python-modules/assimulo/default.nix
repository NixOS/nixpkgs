{ stdenv, buildPythonPackage, fetchsvn, fetchurl, gcc, gfortran, numpy, scipy,
 matplotlib, cython, blas, liblapack, sundials, nose, python, lib }:

# For the official installation instructions, see:
# https://jmodelica.org/assimulo/installation.html

let

  # Assimulo requires Sundials 2.5/2.6
  sundials26 = sundials.overrideDerivation (
    attrs: rec {
      name = "${attrs.pname}-${version}";
      version = "2.6.2";
      src = fetchurl {
        url = "https://computation.llnl.gov/projects/${attrs.pname}/download/${attrs.pname}-${version}.tar.gz";
        sha256 = "0bsdmal7sq90ih5hihqg6isa35cbbwbs865k2zrv1llxa18h3vfq";
      };
    }
  );

in buildPythonPackage rec {

  pname = "assimulo";
  version = "3.0";

  # NOTE: PyPI source tarball is missing some files, so use SVN. See:
  # https://stackoverflow.com/a/54567317/2184571
  src = fetchsvn {
    url = "https://svn.jmodelica.org/assimulo/tags/Assimulo-${version}/";
    rev = "875";
    sha256 = "0n9560qbsrrhs1xvppsrvgi7s2ki3a8751p9qq31dsly23d5mv97";
  };

  buildInputs = [ gfortran gcc ];
  checkInputs = [ nose ];
  propagatedBuildInputs = [ cython numpy scipy matplotlib ];

  # NOTE: Requires static versions of BLAS and LAPACK.
  #
  # TODO: Not sure how to make use of SuperLU. Probably Sundials in nixpkgs
  # should be compiled with SuperLU support? Now there's a debug message: "Could
  # not detect SuperLU support with Sundials, disabling support for SuperLU."
  setupPyBuildFlags = [
    "--blas-home=${blas}/lib"
    "--blas-name=blas"
    "--lapack-home=${liblapack}/lib"
    "--sundials-home=${sundials26}"
  ];

  # I have no idea why dist directory ends up under build, but that's where it
  # is so let's move it. Otherwise the install phase fails on "pushd dist" as
  # dist is not found..
  postBuild = ''
    mv build/dist ./
  '';

  checkPhase = ''
    runHook preCheck
    pushd tests
    nosetests
    popd
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = https://jmodelica.org/assimulo/;
    description = "Simulation package for solving ordinary differential equations";
    # NOTE: The license was specified as LGPL without a version, so I'm assuming
    # any LGPL version is ok.
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ jluttine ];
  };
}
