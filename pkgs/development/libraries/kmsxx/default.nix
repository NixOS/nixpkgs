{ lib
, stdenv
, fetchFromGitHub
, meson
, fmt
, pkg-config
, libdrm
, libevdev
, withPython ? false
, python
, pybind11
, ninja
, git
, cmake
}:

stdenv.mkDerivation {
  pname = "kmsxx";
  version = "2020-12-18";

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "b12aab5d4bb45e77934d9838576a817bc8defe4b";
    sha256 = "0wni7iymf8mj6vymr092l9zq4b73lbm99ad45i5ihcl9y3y4rk2x";
  };

  mesonFlags = lib.optional (!withPython) "-Dpykms=disabled";

  # meson uses CMake to find pybind11, it can't seem to find pybind11 otherwise
  nativeBuildInputs = [ meson ninja pkg-config pybind11 git cmake ];
  buildInputs = [ libdrm fmt libevdev python  ];

  meta = with lib; {
    description = "C++11 library, utilities and python bindings for Linux kernel mode setting";
    homepage = "https://github.com/tomba/kmsxx";
    license = licenses.mpl20;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
