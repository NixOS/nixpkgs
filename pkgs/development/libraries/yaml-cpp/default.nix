{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, cmake
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "yaml-cpp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "yaml-cpp-${version}";
    hash = "sha256-2tFWccifn0c2lU/U1WNg2FHrBohjx8CXMllPJCevaNk=";
  };

  patches = [
    # https://github.com/jbeder/yaml-cpp/issues/774
    # https://github.com/jbeder/yaml-cpp/pull/1037
    (fetchpatch {
      name = "yaml-cpp-Fix-generated-cmake-config.patch";
      url = "https://github.com/jbeder/yaml-cpp/commit/4f48727b365962e31451cd91027bd797bc7d2ee7.patch";
      hash = "sha256-jarZAh7NgwL3xXzxijDiAQmC/EC2WYfNMkYHEIQBPhM=";
    })
    # TODO: Remove with the next release, when https://github.com/jbeder/yaml-cpp/pull/1058 is available
    (fetchpatch {
      name = "yaml-cpp-Fix-pc-paths-for-absolute-GNUInstallDirs.patch";
      url = "https://github.com/jbeder/yaml-cpp/commit/328d2d85e833be7cb5a0ab246cc3f5d7e16fc67a.patch";
      hash = "sha256-1M2rxfbVOrRH9kiImcwcEolXOP8DeDW9Cbu03+mB5Yk=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DYAML_CPP_BUILD_TOOLS=false"
    "-DYAML_BUILD_SHARED_LIBS=${lib.boolToString (!stdenv.hostPlatform.isStatic)}"
    "-DINSTALL_GTEST=false"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater {
    rev-prefix = "yaml-cpp-";
  };

  meta = with lib; {
    description = "A YAML parser and emitter for C++";
    homepage = "https://github.com/jbeder/yaml-cpp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
