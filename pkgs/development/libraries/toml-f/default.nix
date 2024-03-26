{ stdenv
, lib
, fetchFromGitHub
, gfortran
, cmake
, test-drive
}:

stdenv.mkDerivation rec {
  pname = "toml-f";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+cac4rUNpd2w3yBdH1XoCKdJ9IgOHZioZg8AhzGY0FE=";
  };

  nativeBuildInputs = [ gfortran cmake ];

  buildInputs = [ test-drive ];

  outputs = [ "out" "dev" ];

  # Fix the Pkg-Config files for doubled store paths
  postPatch = ''
    substituteInPlace config/template.pc \
      --replace "\''${prefix}/" ""
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "TOML parser implementation for data serialization and deserialization in Fortran";
    license = with licenses; [ asl20 mit ];
    homepage = "https://github.com/toml-f/toml-f";
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.sheepforce ];
  };
}
