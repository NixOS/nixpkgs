{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, gnuradio
, cmake
, pkg-config
, boost
, log4cpp
, python
, swig
, mpir
, gmp
, doxygen
, libpcap
, icu
, thrift
}:

let
  # Each GR major version requires us to pull a specific git revision of the repository
  version = {
    "3.7" = {
      # Last git revision from the `maint-3.7` branch:
      # https://github.com/ghostop14/gr-grnet/tree/maint-3.7
      name = "unstable-2019-08-06";
      gitHash = "beb1cd75d006a982c0a9536e923800c5a0575451";
    };
    "3.8" = {
      # Last git revision from the `maint-3.8` branch:
      # https://github.com/ghostop14/gr-grnet/tree/maint-3.8
      name = "unstable-2020-11-20";
      gitHash = "b02016043b67a15f27134a4f0b0d43f5d1b9ed6d";
    };
    "3.9" = {
      # This revision is taken from the `master` branch.
      name = "unstable-2020-12-30";
      gitHash = "e6dfd140cfda715de9bcef4c1116fcacfeb0c606";
    };
  }.${gnuradio.versionAttr.major};
  src = fetchFromGitHub {
    owner = "ghostop14";
    repo = "gr-grnet";
    rev = "${version.gitHash}";
    sha256 = {
      "3.7" = "LLQ0Jf0Oapecu9gj4IgxOdK7O/OSbHnwNk000GlODxk=";
      "3.8" = "vO8l8nV1/yEQf7pKqBbzIg4KkyCyWu+OkKgISyI3PaQ=";
      "3.9" = "NsL7HCOQmGyexzpH2qbzv8Bq4bsfiDTNEUi96QDOA/g=";
    }.${gnuradio.versionAttr.major};
  };
in
mkDerivation {
  pname = "gr-grnet";
  version = version.name;
  inherit src;
  disabledForGRafter = "3.10";

  patches = [
    # Use cross platform struct ip instead of iphdr
    # https://github.com/ghostop14/gr-grnet/pull/19
    (fetchpatch {
      name = "fix-compilation-on-darwin.patch";
      url = "https://github.com/ghostop14/gr-grnet/commit/52c07daa9ba595b76ffa5dd90c0c96694d95d140.patch";
      sha256 = "sha256-1gJaYLIn09blOhALMfBPROt5YBXaosG41Vsd3+5h518=";
    })
  ];

  buildInputs = [
    boost
    log4cpp
    doxygen
    mpir
    gmp
    libpcap
    icu
  ] ++ (if lib.versionAtLeast gnuradio.versionAttr.major "3.9" then with python.pkgs; [
    pybind11
    numpy
  ] else [
    swig
    thrift
    python.pkgs.thrift
  ]);
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "GNURadio TCP/UDP source and sink blocks rewritten in C++/Boost";
    homepage = "https://github.com/ghostop14/gr-grnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.unix;
  };
}
