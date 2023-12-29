{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "microsoft-gsl";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${version}";
    hash = "sha256-cXDFqt2KgMFGfdh6NGE+JmP4R0Wm9LNHM0eIblYe6zU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ gtest ];

  # error: unsafe buffer access
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unsafe-buffer-usage";

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
