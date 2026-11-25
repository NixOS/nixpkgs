{
  stdenv,
  buildPecl,
  fetchFromGitHub,
  lib,
  php,
  unixodbc,
  libiconv,
}:
buildPecl (finalAttrs: {
  pname = "sqlsrv";
  version = "5.14.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "msphpsql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aB6G+k8A9wsXTW5yo9ofhuIEvz2xDeZk6Qr6lp8J43U=";
  };

  sourceRoot = "${finalAttrs.src.name}/source/sqlsrv";

  # Upstream's source/packagize.sh copies the shared sources into each extension
  postUnpack = ''
    cp -r --no-preserve=mode ${finalAttrs.src.name}/source/shared "$sourceRoot"/shared
  '';

  buildInputs = [ unixodbc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    broken = lib.versionOlder php.version "8.4";
    changelog = "https://github.com/microsoft/msphpsql/releases/tag/v${finalAttrs.version}";
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/microsoft/msphpsql";
    teams = [ lib.teams.php ];
  };
})
