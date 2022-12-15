{ lib
, pkgs
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, lomiri-api
, qtmir
}:

mkDerivation rec {
  pname = "lomiri";
  version = "unstable-2022-12-21";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/lomiri";
    rev = "78416b0b81d68ec90e5e02f43d2f98a2a3969efb";
    sha256 = "sha256-hDWEdc7+teKu4Aj57V8N8u0nkHHHh2lKf5Psx2S0QXQ=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    lomiri-api
    qtmir
  ];

  meta = with lib; {
    description = "Convergent desktop environment (formerly known as unity8)";
    homepage = "https://gitlab.com/ubports/development/core/lomiri";
    license = licenses.gpl3;
    maintainers = with maintainers; [ onny ];
  };

}
