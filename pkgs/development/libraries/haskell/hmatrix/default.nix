{cabal, QuickCheck, HUnit, storableComplex, gsl, liblapack, blas, vector}:

cabal.mkDerivation (self : {
  pname = "hmatrix";
  version = "0.9.3.0";
  sha256 = "1p2c37j29nxq1ijs78xn7293cwjzgcl6hx8ri5qz7nijifmpcrkr";
  propagatedBuildInputs = [QuickCheck HUnit storableComplex blas gsl liblapack vector];
  configureFlags = "-fvector";
  /* dirty hack to find blas at link time */
  postConfigure = ''
    sed -i -e "/^extra-libraries/ s/: /: blas /" hmatrix.buildinfo 
    sed -i -e "/^extra-libraries/ s/$/ blas/" hmatrix.buildinfo
  '';
  extraLibDirs = "--extra-lib-dir=${blas}/lib --extra-lib-dir=${gsl}/lib --extra-lib-dir=${liblapack}/lib";
  meta = {
    description = "Linear algebra and numerical computation";
    maintainers = [ self.stdenv.lib.maintainers.guibert ];
  };
})
