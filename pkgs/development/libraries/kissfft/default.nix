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
    sha256 = "0axmqav2rclw02mix55cch9xl5py540ac15xbmq7xq6n3k492ng2";
  };

  patches = [
    # Allow installation into our prefix
    # Fix installation on Darwin
    # Create necessary directories
    # Make datatype configurable
    (fetchpatch {
      url = "https://github.com/mborgerding/kissfft/pull/38.patch";
      sha256 = "0cp1awl7lr2vqmcwm9lfjs4b4dv9da8mg4hfd821r5ryadpyijj6";
    })
    # Install headers as well
    (fetchpatch {
      url = "https://github.com/mborgerding/kissfft/commit/71df949992d2dbbe15ce707cf56c3fa1e43b1080.patch";
      sha256 = "13h4kzsj388mxxv6napp4gx2ymavz9xk646mnyp1i852dijpmapm";
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
