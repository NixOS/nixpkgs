{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libyaml-cpp";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "yaml-cpp-${version}";
    sha256 = "0ykkxzxcwwiv8l8r697gyqh1nl582krpvi7m7l6b40ijnk4pw30s";
  };

  # implement https://github.com/jbeder/yaml-cpp/commit/52a1378e48e15d42a0b755af7146394c6eff998c
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'option(YAML_BUILD_SHARED_LIBS "Build Shared Libraries" OFF)' \
                'option(YAML_BUILD_SHARED_LIBS "Build yaml-cpp shared library" ''${BUILD_SHARED_LIBS})'
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DYAML_CPP_BUILD_TESTS=OFF" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A YAML parser and emitter for C++";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
