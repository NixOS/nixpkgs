{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "randomX";
  version = "1.2.1";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "tevador";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dfImzwbEfJQcaPZCoWypHiI6dishVRdqS/r+n3tfjvM=";
  };

  meta = with lib; {
    description = "Proof of work algorithm based on random code execution";
    homepage = "https://github.com/tevador/RandomX";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };

}
