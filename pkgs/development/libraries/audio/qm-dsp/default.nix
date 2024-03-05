{ lib, stdenv
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
    sha256 = "1vkb1xr2hjcaw88gig7rknlwsx01lm0w94d2z0rk5vz9ih4fslvv";
  };

  patches = [
    # Make installable
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/qm-dsp/raw/6eb385e2f970c4150f9c8eba73b558318475ed15/f/qm-dsp-install.patch";
      sha256 = "071g30p17ya0pknzqa950pb93vrgp2024ray8axn22c44gvy147c";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/qm-dsp/raw/6eb385e2f970c4150f9c8eba73b558318475ed15/f/qm-dsp-flags.patch";
      sha256 = "127n6j5bsp94kf2m1zqfvkf4iqk1h5f7w778bk7w02vi45nm4x6q";
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

  postInstall = ''
    mv $out/include/qm-dsp/* $out/include
    rmdir $out/include/qm-dsp
  '';

  env.NIX_CFLAGS_COMPILE = "-I${kissfft}/include/kissfft";

  meta = with lib; {
    description = "A C++ library of functions for DSP and Music Informatics purposes";
    homepage = "https://code.soundsoftware.ac.uk/projects/qm-dsp";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
