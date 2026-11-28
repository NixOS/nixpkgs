{
  stdenv,
  buildPecl,
  fetchFromGitHub,
  lib,
  libiconv,
  unixodbc,
  php,
}:
buildPecl (finalAttrs: {
  pname = "pdo_sqlsrv";
  version = "5.14.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "msphpsql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aB6G+k8A9wsXTW5yo9ofhuIEvz2xDeZk6Qr6lp8J43U=";
  };

  sourceRoot = "${finalAttrs.src.name}/source/pdo_sqlsrv";

  # Upstream's source/packagize.sh copies the shared sources into each extension
  postUnpack = ''
    cp -r --no-preserve=mode ${finalAttrs.src.name}/source/shared "$sourceRoot"/shared
  '';

  internalDeps = [ php.extensions.pdo ];

  buildInputs = [ unixodbc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    changelog = "https://github.com/microsoft/msphpsql/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    homepage = "https://github.com/microsoft/msphpsql";
    teams = [ lib.teams.php ];
    broken = lib.versionOlder php.version "8.4";
  };
})
