{ fetchFromGitHub, buildSwiftPackage }:

buildSwiftPackage {
  name = "example-package-dealer";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "example-package-dealer";
    rev = "ca261c5a07d3d9748815697faf0f0394bbab8747";
    sha256 = "137iivdfpbrcx62kc0132ixsw1mqsbhwvbix3gl2pxyy7ffyi20j";
  };

  doCheck = false; # (there are no tests)

  depsSha256 = "12m9ga30lax95mkl2nf7v3pxdmll119vfqclnij978h3yc68c4ky";
}
