{ lib
, pkgs
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, qtsensors
, mir
, libuuid
, process-cpp
, lomiri-app-launch
}:

mkDerivation rec {
  pname = "qtmir";
  version = "unstable-2022-12-18";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/qtmir";
    rev = "c395da87c5b8a4ce75a0ec18c7475bcb007c26f5";
    sha256 = "sha256-NQ4QcYYHdKr1qrSncPOGvEVpQu7AfU+S40p6ViIGgeI=";
  };

  postPatch = ''
    sed -i '/mirclient/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qtsensors
    mir
    libuuid
    process-cpp
    lomiri-app-launch
  ];

  meta = with lib; {
    description = "Mir backed compositor using qt";
    homepage = "https://gitlab.com/ubports/development/core/qtmir";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };

}
