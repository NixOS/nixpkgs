{ lib, stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.2.15";

  src = fetchFromGitLab {
    domain = "gitlab.matrix.org";
    owner = "matrix-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-1mT0mcwssqe+DN502ExkcC/q3w9uBmlTil2gVJsMvvc=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  postPatch = ''
    substituteInPlace olm.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    homepage = "https://gitlab.matrix.org/matrix-org/olm";
    license = licenses.asl20;
    maintainers = with maintainers; [ tilpner oxzi ];
  };
}
