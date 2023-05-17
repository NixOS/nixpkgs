{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "mlib";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "P-p-H-d";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-obQD3TWuGCAs5agnaiJF5Rasn8J283H/cdvKCCAzcB8=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "PREFIX=$(out)" ];

  doCheck = true;

  meta = with lib; {
    description = "Library of generic and type safe containers in pure C language";
    longDescription = ''
      M*LIB (M star lib) is a C library enabling to define and use generic and
      type safe container, aka handling generic containers in in pure C
      language. The objects within the containers can be trivial or very
      complex: they can have their own constructor, destructor, operators or can
      be basic C type like the C type 'int'. This makes it possible to construct
      fully recursive objects (container-of[...]-container-of-type-T), without
      erasing type information (typically using void pointers or resorting to C
      macro to access the container).
    '';
    homepage = "https://github.com/P-p-H-d/mlib";
    changelog = "https://github.com/P-p-H-d/mlib/releases/tag/${src.rev}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
