{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "bpp-core";
  version = "2.4.1";

  src = fetchFromGitHub { owner = "BioPP";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ma2cl677l7s0n5sffh66cy9lxp5wycm50f121g8rx85p95vkgwv";
  };

  nativeBuildInputs = [ cmake ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/bpp-core/bpp-core-targets.cmake  \
      --replace 'set(_IMPORT_PREFIX' '#set(_IMPORT_PREFIX'
  '';
  # prevents cmake from exporting incorrect INTERFACE_INCLUDE_DIRECTORIES
  # of form /nix/store/.../nix/store/.../include,
  # probably due to relative vs absolute path issue

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "http://biopp.univ-montp2.fr/wiki/index.php/Main_Page";
    changelog = "https://github.com/BioPP/bpp-core/blob/master/ChangeLog";
    description = "C++ bioinformatics libraries and tools";
    maintainers = with maintainers; [ bcdarwin ];
    license = licenses.cecill20;
  };
}
