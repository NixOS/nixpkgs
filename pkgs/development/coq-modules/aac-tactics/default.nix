{ lib, mkCoqDerivation, coq, version ? null }:
with lib;

mkCoqDerivation {
  pname = "aac-tactics";

  releaseRev = v: "v${v}";

  release."8.13.0".sha256 = "sha256-MAnMc4KzC551JInrRcfKED4nz04FO0GyyyuDVRmnYTY=";
  release."8.12.0".sha256 = "sha256-dPNA19kZo/2t3rbyX/R5yfGcaEfMhbm9bo71Uo4ZwoM=";
  release."8.11.0".sha256 = "sha256-CKKMiJLltIb38u+ZKwfQh/NlxYawkafp+okY34cGCYU=";
  release."8.10.0".sha256 = "sha256-Ny3AgfLAzrz3FnoUqejXLApW+krlkHBmYlo3gAG0JsM=";
  release."8.9.0".sha256 = "sha256-6Pp0dgYEnVaSnkJR/2Cawt5qaxWDpBI4m0WAbQboeWY=";
  release."8.8.0".sha256 = "sha256-mwIKp3kf/6i9IN3cyIWjoRtW8Yf8cc3MV744zzFM3u4=";
  release."8.6.1".sha256 = "sha256-PfovQ9xJnzr0eh/tO66yJ3Yp7A5E1SQG46jLIrrbZFg=";
  release."8.5.0".sha256 = "sha256-7yNxJn6CH5xS5w/zsXfcZYORa6e5/qS9v8PUq2o02h4=";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = "8.13"; out = "8.13.0"; }
    { case = "8.12"; out = "8.12.0"; }
    { case = "8.11"; out = "8.11.0"; }
    { case = "8.10"; out = "8.10.0"; }
    { case = "8.9"; out = "8.9.0"; }
    { case = "8.8"; out = "8.8.0"; }
    { case = "8.6"; out = "8.6.1"; }
    { case = "8.5"; out = "8.5.0"; }
  ] null;

  mlPlugin = true;

  meta = {
    description = "Coq plugin providing tactics for rewriting universally quantified equations";
    longDescription = ''
      This Coq plugin provides tactics for rewriting universally quantified
      equations, modulo associativity and commutativity of some operator.
      The tactics can be applied for custom operators by registering the
      operators and their properties as type class instances. Many common
      operator instances, such as for Z binary arithmetic and booleans, are
      provided with the plugin.
    '';
    maintainers = with maintainers; [ siraben ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
