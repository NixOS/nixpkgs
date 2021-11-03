{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, gflags, perl }:

stdenv.mkDerivation rec {
  pname = "glog";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${version}";
    sha256 = "17014q25c99qyis6l3fwxidw6222bb269fdlr74gn7pzmzg4lvg3";
  };

  patches = [
    # Fix duplicate-concatenated nix store path in cmake file, see:
    # https://github.com/NixOS/nixpkgs/pull/144561#issuecomment-960296043
    # TODO: Remove when https://github.com/google/glog/pull/733 is merged and available.
    (fetchpatch {
      name = "glog-cmake-Fix-incorrect-relative-path-concatenation.patch";
      url = "https://github.com/google/glog/pull/733/commits/57c636c02784f909e4b5d3c2f0ecbdbb47097266.patch";
      sha256 = "1py93gkzmcyi2ypcwyj3nri210z8fmlaif51yflzmrrv507zd7bi";
    })
  ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ gflags ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  # TODO: Re-enable Darwin tests once we're on a release that has https://github.com/google/glog/issues/709#issuecomment-960381653 fixed
  doCheck = !stdenv.isDarwin;
  checkInputs = [ perl ];

  # Add `build/` directory (`$PWD`) to LD_LIBRARY_PATH so that the built library
  # can be loaded for the tests.
  # Adding to LD_LIBRARY_PATH correctly is nontrivial:
  #   https://jdhao.github.io/2021/07/03/ld_library_path_empty_item/
  #   https://unix.stackexchange.com/questions/162891/append-to-path-like-variable-without-creating-leading-colon-if-unset
  preCheck = ''
    export LD_LIBRARY_PATH=''${LD_LIBRARY_PATH:+''${LD_LIBRARY_PATH}:}''$PWD
  '';

  meta = with lib; {
    homepage = "https://github.com/google/glog";
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ nh2 r-burns ];
  };
}
