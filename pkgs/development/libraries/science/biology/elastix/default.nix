{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, itk, python3, Cocoa }:

stdenv.mkDerivation rec {
  pname    = "elastix";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner  = "SuperElastix";
    repo   = pname;
    rev    = version;
    sha256 = "1mx8kkak2d3ibfrxrh8jkmh2zkdlgl9h578wiw3617zcwaa97bxw";
  };

  patches = [
    (fetchpatch {
      name = "install-executables.patch";  # https://github.com/SuperElastix/elastix/issues/305
      url = "https://github.com/SuperElastix/elastix/commit/8e26cdc0d66f6030c7be085fdc424d84d4fc7546.patch";
      sha256 = "12y9wbpi9jlarnw6fk4iby97jxvx5g4daq9zqblbcmn51r134bj5";
    })
  ];

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ itk ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  doCheck = !stdenv.isDarwin;  # usual dynamic linker issues

  meta = with lib; {
    homepage = "https://elastix.lumc.nl";
    description = "Image registration toolkit based on ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.x86_64;  # libitkpng linker issues with ITK 5.1
    license = licenses.asl20;
  };
}
