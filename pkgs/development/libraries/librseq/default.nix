{ stdenv, fetchFromGitHub
, autoreconfHook, linuxHeaders
}:

stdenv.mkDerivation rec {
  pname = "librseq";
  version = "0.1.0pre54_${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner  = "compudj";
    repo   = "librseq";
    rev    = "152600188dd214a0b2c6a8c66380e50c6ad27154";
    sha256 = "0mivjmgdkgrr6z2gz3k6q6wgnvyvw9xzy65f6ipvqva68sxhk0mx";
  };

  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ linuxHeaders ];

  separateDebugInfo = true;
  enableParallelBuilding = true;

  # The share/ subdir only contains a doc/ with a README.md that just describes
  # how to compile the library, which clearly isn't very useful! So just get
  # rid of it anyway.
  postInstall = ''
    rm -rf $out/share
  '';

  meta = with stdenv.lib; {
    description = "Userspace library for the Linux Restartable Sequence API";
    homepage    = "https://github.com/compudj/librseq";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
