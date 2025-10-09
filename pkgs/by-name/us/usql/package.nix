{
  lib,
  fetchFromGitHub,
  buildGoModule,
  unixODBC,
  icu,
  nix-update-script,
  testers,
  usql,
}:

buildGoModule rec {
  pname = "usql";
  version = "0.19.26";

  src = fetchFromGitHub {
    owner = "xo";
    repo = "usql";
    tag = "v${version}";
    hash = "sha256-Qs/P7WFoc9w3jYLX48F7KSXLYBjrX0DppJmfZvY6Cq8=";
  };

  buildInputs = [
    unixODBC
    icu
  ];

  vendorHash = "sha256-gkC9o7aBZPqHoYODwstRehfaE+Gvtnv7gvKxbnc+BNI=";
  proxyVendor = true;

  # Exclude drivers from the bad group
  # These drivers break too often and are not used.
  #
  excludedPackages = [
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
    "sqlite_vtable"
    "no_adodb"
  ];

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

  meta = {
    description = "Universal command-line interface for SQL databases";
    homepage = "https://github.com/xo/usql";
    changelog = "https://github.com/xo/usql/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "usql";
    maintainers = with lib.maintainers; [
      georgyo
      anthonyroussel
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
