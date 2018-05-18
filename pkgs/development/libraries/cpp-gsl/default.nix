{ stdenv, fetchFromGitHub, cmake, catch }:

stdenv.mkDerivation rec {
  pname = "GSL-unstable";
  version = "2017-02-15";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "c87c123d1b3e64ae2cf725584f0c004da4d90f1c";
    sha256 = "0h8py468bvxnydkjs352d7a9s8hk0ihc7msjkcnzj2d7nzp5nsc1";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=sign-conversion";
  nativeBuildInputs = [ cmake catch ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Microsoft/GSL;
    description = "C++ Core Guideline support library";
    longDescription = ''
     The Guideline Support Library (GSL) contains functions and types that are suggested for
     use by the C++ Core Guidelines maintained by the Standard C++ Foundation.
     This package contains Microsoft's implementation of GSL.
    '';
    platforms = stdenv.lib.platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ yuriaisaka ];
  };
}
