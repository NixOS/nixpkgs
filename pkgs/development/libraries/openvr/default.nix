{ lib
, stdenv
, cmake
, libGL
, jsoncpp
, fetchFromGitHub
, fetchpatch2
}:

stdenv.mkDerivation rec {
  pname = "openvr";
  version = "1.23.8";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZdL1HDRSpPykbV3M0CjCZkOt7XlF7Z7OAhOey2ALeHg=";
  };

  patches = [
    # https://github.com/ValveSoftware/openvr/pull/594
    (fetchpatch2 {
      name = "use-correct-CPP11-definition-for-vsprintf_s.patch";
      url = "https://github.com/ValveSoftware/openvr/commit/0fa21ba17748efcca1816536e27bdca70141b074.patch";
      sha256 = "sha256-0sPNDx5qKqCzN35FfArbgJ0cTztQp+SMLsXICxneLx4=";
    })
    # https://github.com/ValveSoftware/openvr/pull/1716
    (fetchpatch2 {
      name = "add-ability-to-build-with-system-installed-jsoncpp.patch";
      url = "https://github.com/ValveSoftware/openvr/commit/54a58e479f4d63e62e9118637cd92a2013a4fb95.patch";
      sha256 = "sha256-aMojjbNjLvsGev0JaBx5sWuMv01sy2tG/S++I1NUi7U=";
    })
  ];

  postUnpack = ''
    # Move in-tree jsoncpp out to complement the patch above
    # fetchpatch2 is not able to handle these renames
    mkdir source/thirdparty
    mv source/src/json source/thirdparty/jsoncpp
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ jsoncpp libGL ];

  cmakeFlags = [ "-DUSE_SYSTEM_JSONCPP=ON" "-DBUILD_SHARED=1" ];

  meta = with lib;{
    homepage = "https://github.com/ValveSoftware/openvr";
    description = "An API and runtime that allows access to VR hardware from multiple vendors without requiring that applications have specific knowledge of the hardware they are targeting";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pedrohlc Scrumplex ];
    platforms = platforms.unix;
  };
}
