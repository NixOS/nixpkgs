{ stdenv
, fetchFromGitHub
, fetchpatch
, kissfft
}:

stdenv.mkDerivation rec {
  pname = "qm-dsp";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "c4dm";
    repo = pname;
    rev = "v${version}";
    sha256 = "e1PtCIzp7zIz+KKRxEGlAXTNqZ35vPgQ4opJKHIPa+4=";
  };

  patches = [
    # Make installable
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/qm-dsp/raw/6eb385e2f970c4150f9c8eba73b558318475ed15/f/qm-dsp-install.patch";
      sha256 = "7JDg9yOECWG7Ql5lIoC4L++R1gUlKfztvED5Ey4YLxw=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/qm-dsp/raw/6eb385e2f970c4150f9c8eba73b558318475ed15/f/qm-dsp-flags.patch";
      sha256 = "2HRSbSFxC8DPXOgcflyBYeJI3NwO/1CFmyRdvYo09og=";
      postFetch = ''
        sed -i 's~/Makefile~/build/linux/Makefile.linux32~g' "$out"
      '';
    })
  ];

  buildInputs = [
    kissfft
  ];

  makefile = "build/linux/Makefile.linux32";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  NIX_CFLAGS_COMPILE = "-I${kissfft}/include/kissfft";

  meta = with stdenv.lib; {
    description = "A C++ library of functions for DSP and Music Informatics purposes";
    homepage = "https://code.soundsoftware.ac.uk/projects/qm-dsp";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
