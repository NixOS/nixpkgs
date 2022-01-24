{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, fetchurl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "microsoft_gsl";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${version}";
    sha256 = "sha256-gIpyuNlp3mvR8r1Azs2r76ElEodykRLGAwMN4BDJez0=";
  };

  patches = [
    # Search for GoogleTest via pkg-config first, ref: https://github.com/NixOS/nixpkgs/pull/130525
    (fetchurl {
      url = "https://github.com/microsoft/GSL/commit/f5cf01083baf7e8dc8318db3648bc6098dc32d67.patch";
      sha256 = "sha256-uouv35crtly8kYhKyvMyZkqwTKt1jXC6dZjw4sQ6uv0=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ gtest ];

  doCheck = true;

  meta = with lib; {
    description = "C++ Core Guideline support library";
    longDescription = ''
      The Guideline Support Library (GSL) contains functions and types that are suggested for
      use by the C++ Core Guidelines maintained by the Standard C++ Foundation.
      This package contains Microsoft's implementation of GSL.
    '';
    homepage = "https://github.com/Microsoft/GSL";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ thoughtpolice yuriaisaka ];
  };
}
