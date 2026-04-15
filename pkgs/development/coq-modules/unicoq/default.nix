{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "unicoq";
  owner = "unicoq";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = isGe "9.1";
        out = "1.6-9.1";
      }
      {
        case = range "8.20" "9.0";
        out = "1.6-8.20";
      }
      {
        case = range "8.19" "8.19";
        out = "1.6-8.19";
      }
    ] null;
  release."1.6-9.1".rev = "0cf37ef7e638bfaad6e804e17bd80e7bb0e1b717";
  release."1.6-9.1".hash = "sha256-1EKDkj33pg3AsEpckZYqWppPUZV2OkxM2xLq2zvZGMQ=";
  release."1.6-8.20".sha256 = "sha256-zne9LB0lGdqUfrBe8cDK8fwuxfBDFU4PqNlt9nl7rNI=";
  release."1.6-8.19".sha256 = "sha256-fDk60B8AzJwiemxHGgWjNu6PTu6NcJoI9uK7Ww2AT14=";
  releaseRev = v: "v${v}";
  mlPlugin = true;
  meta = {
    description = "Enhanced unification algorithm for Coq";
    license = lib.licenses.mit;
  };
  preBuild = ''
    coq_makefile -f _CoqProject -o Makefile
  '';
}
