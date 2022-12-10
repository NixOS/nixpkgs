{ lib, stdenv, fetchFromGitHub, cmake, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libyaml-cpp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "yaml-cpp-${version}";
    sha256 = "sha256-2tFWccifn0c2lU/U1WNg2FHrBohjx8CXMllPJCevaNk=";
  };

  patches = [
    # https://github.com/jbeder/yaml-cpp/issues/774
    # https://github.com/jbeder/yaml-cpp/pull/1037
    (fetchpatch {
      url = "https://github.com/jbeder/yaml-cpp/commit/4f48727b365962e31451cd91027bd797bc7d2ee7.patch";
      sha256 = "sha256-jarZAh7NgwL3xXzxijDiAQmC/EC2WYfNMkYHEIQBPhM=";
    })
    # TODO: Remove with the next release, when https://github.com/jbeder/yaml-cpp/pull/1058 is available
    (fetchpatch {
      name = "libyaml-cpp-Fix-pc-paths-for-absolute-GNUInstallDirs.patchj";
      url = "https://github.com/jbeder/yaml-cpp/commit/328d2d85e833be7cb5a0ab246cc3f5d7e16fc67a.patch";
      sha256 = "12g5h7lxzd5v16ykay03zww5g28j3k69k228yr3v8fnmyv2spkfl";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DYAML_CPP_BUILD_TESTS=OFF" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A YAML parser and emitter for C++";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
