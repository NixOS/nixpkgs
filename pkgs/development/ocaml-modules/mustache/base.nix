{
  buildDunePackage,
  fetchFromGitHub,
  menhirLib,
  ezjsonm,
  ounit,
  doCheck ? true,
  nativeBuildInputs ? [ ],
}:
buildDunePackage rec {
  pname = "mustache";
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "rgrinberg";
    repo = "ocaml-mustache";
    tag = "v${version}";
    hash = "sha256-7rdp7nrjc25/Nuj/cf78qxS3Qy4ufaNcKjSnYh4Ri8U=";
  };

  inherit nativeBuildInputs;
  buildInputs = [ ezjsonm ];
  propagatedBuildInputs = [ menhirLib ];

  inherit doCheck;
  checkInputs = [ ounit ];
}
