{ stdenv
, lib
, fetchFromGitHub
, gfortran
, pkg-config
, json-fortran
, cmake
}:

stdenv.mkDerivation rec {
  pname = "mctc-lib";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AXjg/ZsitdDf9fNoGVmVal1iZ4/sxjJb7A9W4yye/rg=";
  };

  nativeBuildInputs = [ gfortran pkg-config cmake ];

  buildInputs = [ json-fortran ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/${pname}.pc \
      --replace "''${prefix}/" ""
  '';

  doCheck = true;

  meta = with lib; {
    description = "Modular computation tool chain library";
    homepage = "https://github.com/grimme-lab/mctc-lib";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
