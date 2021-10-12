{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libyaml-cpp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "yaml-cpp-${version}";
    sha256 = "sha256-2tFWccifn0c2lU/U1WNg2FHrBohjx8CXMllPJCevaNk=";
  };

  # implement https://github.com/jbeder/yaml-cpp/commit/52a1378e48e15d42a0b755af7146394c6eff998c
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'option(YAML_BUILD_SHARED_LIBS "Build Shared Libraries" OFF)' \
                'option(YAML_BUILD_SHARED_LIBS "Build yaml-cpp shared library" ''${BUILD_SHARED_LIBS})'
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DYAML_CPP_BUILD_TESTS=OFF" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A YAML parser and emitter for C++";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
