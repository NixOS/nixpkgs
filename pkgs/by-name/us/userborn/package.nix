{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  mkpasswd,
}:

rustPlatform.buildRustPackage rec {
  pname = "userborn";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "userborn";
    rev = version;
    hash = "sha256-aptFDrL9RPPTu4wp2ee3LVaEruRdCWtLGIKdOgsR+/s=";
  };

  sourceRoot = "${src.name}/rust/userborn";

  cargoHash = "sha256-m39AC26E0Pxu1E/ap2kSwr5uznJNgExf5QUrZ+zTNX0=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ mkpasswd ];

  nativeCheckInputs = [ mkpasswd ];

  postInstall = ''
    wrapProgram $out/bin/userborn --prefix PATH : ${lib.makeBinPath [ mkpasswd ]}
  '';

  stripAllList = [ "bin" ];

  meta = with lib; {
    homepage = "https://github.com/nikstur/userborn";
    description = "Declaratively bear (manage) Linux users and groups";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "userborn";
  };
}
