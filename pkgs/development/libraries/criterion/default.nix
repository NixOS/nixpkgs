{ lib, stdenv, fetchFromGitHub, boxfort, meson, libcsptr, pkg-config, gettext
, cmake, ninja, protobuf, libffi, libgit2, dyncall, nanomsg, nanopbMalloc
, python3Packages }:

stdenv.mkDerivation rec {
  pname = "criterion";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "Criterion";
    rev = "v${version}";
    sha256 = "KT1XvhT9t07/ubsqzrVUp4iKcpVc1Z+saGF4pm2RsgQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ meson ninja cmake pkg-config protobuf ];

  buildInputs = [
    boxfort.dev
    dyncall
    gettext
    libcsptr
    nanomsg
    nanopbMalloc
    libgit2
    libffi
  ];

  nativeCheckInputs = with python3Packages; [ cram ];

  doCheck = true;
  checkTarget = "test";

  postPatch = ''
    patchShebangs ci/isdir.py src/protocol/gen-pb.py
  '';

  outputs = [ "dev" "out" ];

  meta = with lib; {
    description = "A cross-platform C and C++ unit testing framework for the 21th century";
    homepage = "https://github.com/Snaipe/Criterion";
    license = licenses.mit;
    maintainers = with maintainers; [
      thesola10
      Yumasi
    ];
    platforms = platforms.unix;
  };
}
