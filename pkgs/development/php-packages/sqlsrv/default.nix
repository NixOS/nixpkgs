{
  stdenv,
  buildPecl,
  lib,
  unixODBC,
  libiconv,
}:

buildPecl {
  pname = "sqlsrv";

  version = "5.12.0";
  sha256 = "sha256-qeu4gLKlWNPWaE9uaALFPFv/pJ4e5g0Uc6cST8nLcq0=";

  buildInputs = [ unixODBC ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

<<<<<<< HEAD
  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [ lib.teams.php ];
=======
  meta = with lib; {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [ teams.php ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
