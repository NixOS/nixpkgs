{
  lib,
  stdenv,
  buildDunePackage,
  darwin,
  conan-unix,
  dune-site,
  alcotest,
  conan-database,
  crowbar,
  fmt,
  rresult,
}:

buildDunePackage {
  pname = "conan-cli";
  inherit (conan-unix) version src meta;

  buildInputs = [
    conan-unix
    dune-site
  ];

  doCheck = true;

  preCheck = ''
    export DUNE_CACHE=disabled
  '';

  nativeCheckInputs = [
    conan-database
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool # codesign
  ];

  checkInputs = [
    alcotest
    conan-database
    crowbar
    fmt
    rresult
  ];
}
