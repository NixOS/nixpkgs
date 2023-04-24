{ stdenv
, lib
, fetchFromGitHub
, gfortran
, cmake
, test-drive
}:

stdenv.mkDerivation rec {
  pname = "toml-f";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8FbnUkeJUP4fiuJCroAVDo6U2M7ZkFLpG2OYrapMYtU=";
  };

  nativeBuildInputs = [ gfortran cmake ];

  buildInputs = [ test-drive ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/${pname}.pc \
      --replace "''${prefix}/" ""
  '';

  doCheck = true;

  meta = with lib; {
    description = "TOML parser implementation for data serialization and deserialization in Fortran";
    license = with licenses; [ asl20 mit ];
    homepage = "https://github.com/toml-f/toml-f";
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.sheepforce ];
  };
}
