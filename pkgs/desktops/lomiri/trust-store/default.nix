{ mkDerivation, lib, fetchFromGitHub
, cmake, cmake-extras, gtest, gmock, properties-cpp
, qtbase, qtdeclarative, boost, mir_1, glog, process-cpp, dbus-cpp, libapparmor, dbus
}:

mkDerivation rec {
  pname = "trust-store-unstable";
  version = "2020-10-08";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "trust-store";
    rev = "ad94b8bcdfeafc7ff7c80bc3693f8fecb4b9b70e";
    sha256 = "1qfi1zmipx8rjb4hkibj6q9g9ps2rw8fqd7j3w739rqbikknp9z6";
  };

  # patches = [
  #   ../patches/trust-store/0001-Remove-coverage-report.patch
  #   ../patches/trust-store/0002-Use-pkg-config-for-GTest.patch
  # ];

  nativeBuildInputs = [ cmake cmake-extras gtest gmock properties-cpp ];

  buildInputs = [ qtbase qtdeclarative boost mir_1 glog process-cpp dbus-cpp libapparmor dbus ];

  meta = with lib; {
    description = "C++11 library for persisting trust requests";
    longDescription = ''
      An API for creating, reading, updating and deleting trust requests answered by
      users.
      Provides a common implementation of a trust store to be used by trusted
      helpers.
    '';
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
