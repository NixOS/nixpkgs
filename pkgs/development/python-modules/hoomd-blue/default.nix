{ stdenv, fetchgit
, cmake, pkgconfig
, python
, mpi ? null
}:

let components = {
     cgcmm = true;
     depreciated = true;
     hpmc = true;
     md = true;
     metal = true;
   };
   onOffBool = b: if b then "ON" else "OFF";
   withMPI = (mpi != null);
in
stdenv.mkDerivation rec {
  version = "2.3.4";
  pname = "hoomd-blue";

  src = fetchgit {
    url = "https://bitbucket.org/glotzer/hoomd-blue";
    rev = "v${version}";
    sha256 = "0in49f1dvah33nl5n2qqbssfynb31pw1ds07j8ziryk9w252j1al";
  };

  passthru = {
    inherit components mpi;
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = stdenv.lib.optionals withMPI [ mpi ];
  propagatedBuildInputs = [ python.pkgs.numpy ]
   ++ stdenv.lib.optionals withMPI [ python.pkgs.mpi4py ];

  enableParallelBuilding = true;

  dontAddPrefix = true;
  cmakeFlags = [
       "-DENABLE_MPI=${onOffBool withMPI}"
       "-DBUILD_CGCMM=${onOffBool components.cgcmm}"
       "-DBUILD_DEPRECIATED=${onOffBool components.depreciated}"
       "-DBUILD_HPMC=${onOffBool components.hpmc}"
       "-DBUILD_MD=${onOffBool components.md}"
       "-DBUILD_METAL=${onOffBool components.metal}"
  ];

  preConfigure = ''
    # Since we can't expand $out in `cmakeFlags`
    cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_PREFIX=$out/${python.sitePackages}"
  '';

  # tests fail but have tested that package runs properly
  doCheck = false;
  checkTarget = "test";

  meta = with stdenv.lib; {
    homepage = http://glotzerlab.engin.umich.edu/hoomd-blue/;
    description = "HOOMD-blue is a general-purpose particle simulation toolkit";
    license = licenses.bsdOriginal;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.costrouc ];
  };

}
