{ lib
, fetchFromGitHub
, ocamlPackages
}:

ocamlPackages.buildDunePackage rec {
  pname = "stanc";
  version = "2.33.1";

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = "stanc3";
    rev = "v${version}";
    hash = "sha256-DeQOiYJ5OHIMXcYHTYlObJnxM2Rqf6pSN4T7sAGw+wg=";
  };

  # Error: This expression has type [ `Use_Sys_unix ]
  postPatch = ''
    substituteInPlace test/integration/run_bin_on_args.ml \
      --replace "if Sys.file_exists (to_windows path) then to_windows cmd else cmd" "cmd"
  '';

  nativeBuildInputs = with ocamlPackages; [
    menhir
  ];
  buildInputs = with ocamlPackages; [
    core_unix
    menhirLib
    ppx_deriving
    fmt
    yojson
  ];

  meta = with lib; {
    homepage = "https://github.com/stan-dev/stanc3";
    description = "The Stan compiler and utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
