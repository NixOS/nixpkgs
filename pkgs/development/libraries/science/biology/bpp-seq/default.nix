{ stdenv, fetchFromGitHub, cmake, bpp-core }:

stdenv.mkDerivation rec {
  pname = "bpp-seq";

  inherit (bpp-core) version;

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mc09g8jswzsa4wgrfv59jxn15ys3q8s0227p1j838wkphlwn2qk";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ bpp-core ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/${pname}/${pname}-targets.cmake  \
      --replace 'set(_IMPORT_PREFIX' '#set(_IMPORT_PREFIX'
  '';
  # prevents cmake from exporting incorrect INTERFACE_INCLUDE_DIRECTORIES
  # of form /nix/store/.../nix/store/.../include,
  # probably due to relative vs absolute path issue

  doCheck = !stdenv.isDarwin;

  meta = bpp-core.meta // {
    changelog = "https://github.com/BioPP/bpp-seq/blob/master/ChangeLog";
  };
}
