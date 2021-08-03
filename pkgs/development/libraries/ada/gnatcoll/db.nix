{ stdenv
, lib
, fetchFromGitHub
, gnat
, gprbuild
, which
, gnatcoll-core
, xmlada
, component
# components built by this derivation other components depend on
, gnatcoll-sql
, gnatcoll-sqlite
, gnatcoll-xref
# component specific extra dependencies
, gnatcoll-iconv
, gnatcoll-readline
, sqlite
, postgresql
}:

let
  libsFor = {
    gnatcoll_db2ada = [
      gnatcoll-sql
    ];
    gnatinspect = [
      gnatcoll-sqlite
      gnatcoll-readline
      gnatcoll-xref
    ];
    postgres = [
      gnatcoll-sql
      postgresql
    ];
    sqlite = [
      gnatcoll-sql
      sqlite
    ];
    xref = [
      gnatcoll-iconv
      gnatcoll-sqlite
    ];
  };

  # These components are just tools and don't install a library
  onlyExecutable = builtins.elem component [
    "gnatcoll_db2ada"
    "gnatinspect"
  ];
in

stdenv.mkDerivation rec {
  pname = "gnatcoll-${component}";
  version = "21.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gnatcoll-db";
    rev = "v${version}";
    sha256 = "0fdfng3yfy645nlw8l3c2za0zkn6pdhkvyrw20wnjx4k26glgb6r";
  };

  patches = lib.optionals (component == "sqlite") [
    # fixes build of the static sqlite component
    # when building against the system libsqlite3
    # See https://github.com/AdaCore/gprbuild/issues/27#issuecomment-298444608
    ./gnatcoll-db-sqlite-static-external.patch
  ];

  # Link executables dynamically unless specified by the platform,
  # as we usually do in nixpkgs where possible
  postPatch = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    for f in gnatcoll_db2ada/Makefile gnatinspect/Makefile; do
      substituteInPlace "$f" --replace "=static" "=relocatable"
    done
  '';

  nativeBuildInputs = [
    gnat
    gprbuild
    which
  ];

  # Propagate since GPRbuild needs to find referenced .gpr files
  # and other libraries to link against when static linking is used.
  # For executables this is of course not relevant and we can reduce
  # the closure size dramatically
  ${if onlyExecutable then "buildInputs" else "propagatedBuildInputs"} = [
    gnatcoll-core
  ] ++ libsFor."${component}" or [];

  makeFlags = [
    "-C" component
    "PROCESSORS=$(NIX_BUILD_CORES)"
    # confusingly, for gprbuild --target is autoconf --host
    "TARGET=${stdenv.hostPlatform.config}"
    "prefix=${placeholder "out"}"
  ] ++ lib.optional (component == "sqlite") [
    # link against packaged, not vendored libsqlite3
    "GNATCOLL_SQLITE=external"
  ];

  meta = with lib; {
    description = "GNAT Components Collection - Database packages";
    homepage = "https://github.com/AdaCore/gnatcoll-db";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.all;
  };
}
