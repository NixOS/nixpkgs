{ stdenv, fetchFromGitHub
, cmake, cmake-extras, intltool, python3
, ubuntu-app-launch, glib, mir_1, json-glib, dbus-test-runner, sqlite, libapparmor, dbus
}:

stdenv.mkDerivation rec {
  pname = "url-dispatcher-unstable";
  version = "2020-09-25";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "url-dispatcher";
    rev = "58a498dbd19e46f3baa17629bb8b56be860cb738";
    sha256 = "1hajhjncmdpdyn0phfspkafcnwr8ksxiyz1c778f9pwhp20c9sh4";
  };

  # patches = [
  #   ../patches/url-dispatcher/0001-Remove-coverage-report.patch
  #   ../patches/url-dispatcher/0002-Use-pkg-config-for-GTest.patch
  # ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "--variable interfaces_dir" "--define-variable datadir=$out/etc --variable interfaces_dir"
    substituteInPlace data/CMakeLists.txt \
      --replace "/usr" "$out"
    substituteInPlace tests/CMakeLists.txt \
      --replace '$''\{GMOCK_LIBRARIES}' '$''\{GTEST_BOTH_LIBRARIES} $''\{GMOCK_LIBRARIES}'
    substituteInPlace tests/url_dispatcher_testability/CMakeLists.txt \
      --replace 'python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"' 'echo "${placeholder "out"}/${python3.sitePackages}"'
  '';

  nativeBuildInputs = [
    cmake cmake-extras intltool
  ];

  buildInputs = [ ubuntu-app-launch glib mir_1 json-glib dbus-test-runner sqlite libapparmor dbus ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-Wno-error=deprecated-declarations"
  ];

  meta = with stdenv.lib; {
    description = "Service to allow sending of URLs and get handlers started";
    longDescription = ''
      Allows applications to request a URL to be opened and handled by another
      process without seeing the list of other applications on the system or
      starting them inside its own Application Confinement.
    '';
    homepage = "https://launchpad.net/url-dispatcher";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
