{ lib, stdenv, fetchgit
, gettext
, python3
, elfutils
}:

stdenv.mkDerivation {
  pname = "libsystemtap";
  version = "5.0";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-5.0";
    hash = "sha256-dIBpySBTFn01CNtYwbXEramUlcYHPF6O/Ffr1BxdAH0=";
  };

  dontBuild = true;

  nativeBuildInputs = [ gettext python3 elfutils ];

  installPhase = ''
    mkdir -p $out/include
    cp -r includes/* $out/include/
  '';

  meta = with lib; {
    description = "Statically defined probes development files";
    homepage = "https://sourceware.org/systemtap/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ lib.maintainers.farlion ];
  };
}
