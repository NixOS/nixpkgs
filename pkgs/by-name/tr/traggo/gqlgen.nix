{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gqlgen";
  version = "0.17.85";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "gqlgen";
    tag = "v${version}";
    hash = "sha256-U2qbOjWUE1MfrMJTVaB59Osax8B6CKMlk6uqGioVgBk=";
  };

  vendorHash = "sha256-9rBdr1fP5LKioz2c6lAZEdcDnG2JL2CO1VXK5+MwGEs=";
  subPackages = [ "." ];
  doCheck = false;
}
