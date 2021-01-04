{ mkDerivation, lib, fetchFromGitHub
, cmake, cmake-extras, xvfb_run, dbus-test-runner
, qtbase, boost, glog, libnih
}:

mkDerivation rec {
  pname = "ubuntu-download-manager-unstable";
  version = "2020-11-11";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "ubuntu-download-manager";
    rev = "4f5aafc91126b03c101061fa1d7b85f49add67d8";
    sha256 = "0qs6islq4n6w64qvv8zd2pv58wj8mn8v6kxp404y1bi8nsaz3dg0";
  };

  postPatch = ''
    for cmakeFile in src/{up,down}loads/daemon/CMakeLists.txt; do
      substituteInPlace "$cmakeFile" \
        --replace "/usr" "$out" \
        --replace "/etc" "$out/etc"
    done
  '';

  nativeBuildInputs = [ cmake cmake-extras xvfb_run dbus-test-runner ];

  buildInputs = [ qtbase boost glog libnih ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-Wno-error=deprecated-declarations"
  ];

  postInstall = "mv $out/lib{exec,}/pkgconfig";

  meta = with lib; {
    description = "A daemon that offers a DBus API to perform downloads";
    homepage = "https://launchpad.net/ubuntu-download-manager";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
