{ stdenv, fetchFromGitHub, cmake, bpp-core, bpp-seq }:

stdenv.mkDerivation rec {
  pname = "bpp-popgen";

  inherit (bpp-core) version;

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bz0fhrq3dri6a0hvfc3zlvrns8mrzzlnicw5pyfa812gc1qwfvh";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ bpp-core bpp-seq ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/${pname}/${pname}-targets.cmake  \
      --replace 'set(_IMPORT_PREFIX' '#set(_IMPORT_PREFIX'
  '';
  # prevents cmake from exporting incorrect INTERFACE_INCLUDE_DIRECTORIES
  # of form /nix/store/.../nix/store/.../include,
  # probably due to relative vs absolute path issue

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = bpp-core.meta // {
    homepage = "https://github.com/BioPP/bpp-popgen";
    changelog = "https://github.com/BioPP/bpp-popgen/blob/master/ChangeLog";
  };
}
