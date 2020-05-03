{ stdenv
, fetchFromGitHub
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "kissfft";
  version = "131";

  src = fetchFromGitHub {
    owner = "mborgerding";
    repo = pname;
    rev = "v${version}";
    sha256 = "4lmRyBzW4H5wXb0EpgAp/hbaE2SslB6rAJyyLLbCtSs=";
  };

  patches = [
    # Allow installation into our prefix
    # Fix installation on Darwin
    # Create necessary directories
    # Make datatype configurable
    (fetchpatch {
      url = "https://github.com/mborgerding/kissfft/pull/38.patch";
      sha256 = "Rsrob1M+lxwEag6SV5FqaTeyiJaOpspZxVtkeihX4TI=";
    })
    # Install headers as well
    (fetchpatch {
      url = "https://github.com/mborgerding/kissfft/commit/71df949992d2dbbe15ce707cf56c3fa1e43b1080.patch";
      sha256 = "9ap6ZWyioBiut9UQM3v6W1Uv+iP3Kmt27xWhIfWfBI4=";
    })
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DATATYPE=double"
  ];

  meta = with stdenv.lib; {
    description = "A mixed-radix Fast Fourier Transform based up on the KISS principle";
    homepage = "https://github.com/mborgerding/kissfft";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
