{ lib, stdenv, fetchFromGitHub, cmake, itk, Cocoa }:

stdenv.mkDerivation rec {
  pname    = "elastix";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "SuperElastix";
    repo = pname;
    rev = version;
    hash = "sha256-wFeLU8IwiF43a9TAvecQG+QMw88PQZdJ8sI1Zz3ZeXc=";
  };

  nativeBuildInputs = [ cmake ];
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
