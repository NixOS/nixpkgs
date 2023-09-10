{ stdenv
, lib
, fetchFromGitHub
, cmake
, gfortran
, mctc-lib
}:

stdenv.mkDerivation rec {
  pname = "mstore";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dN2BulLS/ENRFVdJIrZRxgBV8S4d5+7BjTCGnhBbf4I=";
  };

  nativeBuildInputs = [ cmake gfortran ];

  buildInputs = [ mctc-lib ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/${pname}.pc \
      --replace "''${prefix}/" ""
  '';

  meta = with lib; {
    description = "Molecular structure store for testing";
    license = licenses.asl20;
    homepage = "https://github.com/grimme-lab/mstore";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
