{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "unittest-cpp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "unittest-cpp";
    repo = "unittest-cpp";
    rev = "v${version}";
    sha256 = "0sxb3835nly1jxn071f59fwbdzmqi74j040r81fanxyw3s1azw0i";
  };

  patches = [
    # GCC12 Patch
    (fetchpatch {
      url = "https://github.com/unittest-cpp/unittest-cpp/pull/185/commits/f361c2a1034c02ba8059648f9a04662d6e2b5553.patch";
      hash = "sha256-xyhV2VBelw/uktUXSZ3JBxgG+8/Mout/JiXEZVV2+2Y=";
    })
  ];

  # Fix 'Version:' setting in .pc file. TODO: remove once upstreamed:
  #     https://github.com/unittest-cpp/unittest-cpp/pull/188
  cmakeFlags = [ "-DPACKAGE_VERSION=${version}" ];

  nativeBuildInputs = [ cmake ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/unittest-cpp/unittest-cpp";
    description = "Lightweight unit testing framework for C++";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
