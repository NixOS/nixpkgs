{ stdenv
, cmake
, fetchurl
, python }:

stdenv.mkDerivation rec {
  pname = "sundials";
  version = "4.1.0";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ python ];

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
    sha256 = "19ca4nmlf6i9ijqcibyvpprxzsdfnackgjs6dw51fq13gg1f2398";
  };

  patches = [ (fetchurl {
    # https://github.com/LLNL/sundials/pull/19
    url = "https://github.com/LLNL/sundials/commit/1350421eab6c5ab479de5eccf6af2dcad1eddf30.patch";
    sha256 = "0g67lixp9m85fqpb9rzz1hl1z8ibdg0ldwq5z6flj5zl8a7cw52l";
  })];

  cmakeFlags = [
    "-DEXAMPLES_INSTALL_PATH=${placeholder "out"}/share/examples"
  ];

  doCheck = true;
  checkPhase = "make test";

  meta = with stdenv.lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = https://computation.llnl.gov/projects/sundials;
    platforms   = platforms.all;
    maintainers = with maintainers; [ flokli idontgetoutmuch ];
    license     = licenses.bsd3;
  };

}
