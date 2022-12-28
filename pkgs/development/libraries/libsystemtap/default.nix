{ lib, stdenv, fetchgit
, gettext
, python3
, elfutils
}:

stdenv.mkDerivation {
  pname = "libsystemtap";
  version = "4.6";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-4.6";
    hash = "sha256-z7OUy0VGxK39aYCWFfvJnWk34Je0R+51kK5pGh7TzXM=";
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
