{ lib, stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  pname = "l-smash";
  version = "2.14.5";

  src = fetchFromGitHub {
    owner = "l-smash";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rcq9727im6kd8da8b7kzzbzxdldvmh5nsljj9pvr4m3lj484b02";
  };

  nativeBuildInputs = [ which ];

  configureFlags = [
    "--cc=cc"
    "--cross-prefix=${stdenv.cc.targetPrefix}"
  ];

  meta = with lib; {
    homepage = "http://l-smash.github.io/l-smash/";
    description = "MP4 container utilities";
    license = licenses.isc;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
