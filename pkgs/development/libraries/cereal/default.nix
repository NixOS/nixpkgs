{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:
stdenv.mkDerivation rec {
  pname = "cereal";
  version = "1.3.0";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "USCiLab";
    repo = "cereal";
    rev = "v${version}";
    sha256 = "0hc8wh9dwpc1w1zf5lfss4vg5hmgpblqxbrpp1rggicpx9ar831p";
  };

  patches = [
    # https://nvd.nist.gov/vuln/detail/CVE-2020-11105
    # serialized std::shared_ptr variables cannot always be expected to
    # serialize back into their original values. This can have any number of
    # consequences, depending on the context within which this manifests.
    (fetchpatch {
      name = "CVE-2020-11105.patch";
      url = "https://github.com/USCiLab/cereal/commit/f27c12d491955c94583512603bf32c4568f20929.patch";
      sha256 = "CIkbJ7bAN0MXBhTXQdoQKXUmY60/wQvsdn99FaWt31w=";
    })
  ];

  cmakeFlags = [ "-DJUST_INSTALL_CEREAL=yes" ];

  meta = with lib; {
    description = "A header-only C++11 serialization library";
    homepage    = "https://uscilab.github.io/cereal/";
    platforms   = platforms.all;
    license     = licenses.mit;
  };
}
