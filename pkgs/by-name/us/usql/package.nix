{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, unixODBC
, icu
, nix-update-script
, testers
, usql
}:

buildGoModule rec {
  pname = "usql";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "xo";
    repo = "usql";
    rev = "v${version}";
    hash = "sha256-lGdFxbD8O5kmiMdM0EPJF1jmnyVs1WkK4Y+qC71t4EY=";
  };

  buildInputs = [ unixODBC icu ];

  vendorHash = "sha256-2s6DLVUpizFQpOOs0jBinBlIhIRVzLxveUcWCuSgW68=";
  proxyVendor = true;

  # Exclude broken genji, hive & impala drivers (bad group)
  # These drivers break too often and are not used.
  #
  # See https://github.com/xo/usql/pull/347
  #
  excludedPackages = [
    "genji"
    "hive"
    "impala"
  ];

  # These tags and flags are copied from build.sh
  tags = [
    "most"
    "sqlite_app_armor"
    "sqlite_fts5"
    "sqlite_introspect"
    "sqlite_json1"
    "sqlite_math_functions"
    "sqlite_stat4"
    "sqlite_userauth"
    "sqlite_vtable"
    "no_adodb"
  ];

  # Work around https://github.com/NixOS/nixpkgs/issues/166205.
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xo/usql/text.CommandVersion=${version}"
  ];

  # All the checks currently require docker instances to run the databases.
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = usql;
      command = "usql --version";
    };
  };

  meta = with lib; {
    description = "Universal command-line interface for SQL databases";
    homepage = "https://github.com/xo/usql";
    changelog = "https://github.com/xo/usql/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "usql";
    maintainers = with maintainers; [ georgyo anthonyroussel ];
    platforms = with platforms; linux ++ darwin;
  };
}
