{ stdenv, fetchFromGitHub, cmake, catch }:

stdenv.mkDerivation rec {
  pname = "GSL";
  version = "2.0.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${version}";
    sha256 = "1kxfca9ik934nkzyn34ingkyvwpc09li81cg1yc6vqcrdw51l4ri";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=sign-conversion";
  postPatch = ''
    sed -i 's/-Wno-unknown-attributes/-Wno-error=catch-value/' tests/CMakeLists.txt
  '';
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
