{lib, stdenv, fetchgit, gettext, python2, elfutils}:

stdenv.mkDerivation {
  pname = "libsystemtap";
  version = "3.2";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "4051c70c9318c837981384cbb23f3e9eb1bd0892";
    sha256 = "0sd8n3j3rishks3gyqj2jyqhps7hmlfjyz8i0w8v98cczhhh04rq";
    fetchSubmodules = false;
  };

  dontBuild = true;

  nativeBuildInputs = [ gettext python2 elfutils ];

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
