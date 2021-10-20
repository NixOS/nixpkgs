{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "cmark";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = pname;
    rev = version;
    sha256 = "sha256-UjDM2N6gCwO94F1nW3qCP9JX42MYAicAuGTKAXMy1Gg=";
  };

  patches = [
    # Fix libcmark.pc paths (should be incorporated next release)
    (fetchpatch {
      url = "https://github.com/commonmark/cmark/commit/15762d7d391483859c241cdf82b1615c6b6a5a19.patch";
      sha256 = "sha256-wdyK1tQolgfiwYMAaWMQZdCSbMDCijug5ykpoDl/HwI=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # https://github.com/commonmark/cmark/releases/tag/0.30.1
    # recommends distributions dynamically link
    "-DCMARK_STATIC=OFF"
  ];

  doCheck = true;

  preCheck = let
    lib_path = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in ''
    export ${lib_path}=$(readlink -f ./src)
  '';

  meta = with lib; {
    description = "CommonMark parsing and rendering library and program in C";
    homepage = "https://github.com/jgm/cmark";
    maintainers = [ maintainers.michelk ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}
