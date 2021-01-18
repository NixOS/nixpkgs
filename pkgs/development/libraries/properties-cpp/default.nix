{ stdenv, fetchFromGitHub
, cmake, cmake-extras
}:

stdenv.mkDerivation rec {
  pname = "properties-cpp-unstable";
  version = "2014-07-30";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "properties-cpp";
    rev = "20742e41f883161534218191b593b32318f838af";
    sha256 = "1dj3imffbl8fqf3nsymcgv92k0h5mp0df4xnxbr6zrjqafi7h89a";
  };

  postPatch = ''
    substituteInPlace tests/CMakeLists.txt \
      --replace 'find_package(Gtest REQUIRED)' 'find_package(PkgConfig REQUIRED)''\nfind_package(GMock REQUIRED)'
  '';

  nativeBuildInputs = [ cmake cmake-extras ];

  meta = with stdenv.lib; {
    homepage = "https://launchpad.net/properties-cpp";
    description = "A very simple convenience library for handling properties and signals in C++11";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ edwtjo ];
  };
}
