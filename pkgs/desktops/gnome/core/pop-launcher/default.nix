{ stdenv, fetchFromGitHub, rustPlatform, lib, pkg-config, openssl, gtk3 }:

stdenv.mkDerivation rec {
  pname = "pop-launcher";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = version;
    sha256 = "sha256-eo/4ou9cW27IxS5C5l+KV6DU1gbe+Vbv9oVTTHPx0uI=";
  };

  patches = [ ./custom-base-path.patch ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-47s9tE2SImf8VhiKUXI4Kkk0ctamVktCKQsM8WpJOJM=";
  };

  nativeBuildInputs = [ pkg-config rustPlatform.cargoSetupHook rustPlatform.rust.cargo ];
  buildInputs = [ openssl gtk3 ];

  installFlags = [ "BASE_PATH=$(out)" ];

  meta = with lib; {
    description = "Modular IPC-based desktop launcher service for Pop!_OS";
    maintainers = with maintainers; [ Enzime ];
    license = licenses.mpl20;
    homepage = "https://github.com/pop-os/launcher";
  };
}
