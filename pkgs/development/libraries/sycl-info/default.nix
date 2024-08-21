{ lib, stdenv
, fetchFromGitHub
, cmake
, ninja
, ocl-icd
, opencl-headers
, lyra
, nlohmann_json
, ronn
, doctest
}:

stdenv.mkDerivation rec {
  pname = "sycl-info";
  version = "unstable-2019-11-19";

  src = fetchFromGitHub {
    owner = "codeplaysoftware";
    repo = "sycl-info";
    rev = "b47d498ee2d6b77ec21972de5882e8e12efecd6c";
    sha256 = "0fy0y1rcfb11p3vijd8wym6xkaicav49pv2bv2l18rma929n1m1m";
  };

  buildInputs = [
    nlohmann_json
    ronn
    opencl-headers
    ocl-icd
    doctest
    lyra
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
    "-DBUILD_DOCS=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DLYRA_INCLUDE_DIRS=${lib.getDev lyra}/include"
  ];

  # Required for ronn to compile the manpage.
  RUBYOPT = "-KU -E utf-8:utf-8";

  meta = with lib;
    {
      homepage = "https://github.com/codeplaysoftware/sycl-info";
      description = "Tool to show information about available SYCL implementations";
      mainProgram = "sycl-info";
      platforms = platforms.linux;
      license = licenses.asl20;
      maintainers = with maintainers; [ davidtwco ];
    };
}
