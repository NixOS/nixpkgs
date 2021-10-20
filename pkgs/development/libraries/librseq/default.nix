{ lib, stdenv, fetchFromGitHub
, autoreconfHook, linuxHeaders
}:

stdenv.mkDerivation rec {
  pname = "librseq";
  version = "0.1.0pre70_${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner  = "compudj";
    repo   = "librseq";
    rev    = "d1cdec98d476b16ca5e2d9d7eabcf9f1c97e6111";
    sha256 = "0vgillrxc1knq591gjj99x2ws6q1xpm5dmfrhsxisngfpcnjr10v";
  };

  outputs = [ "out" "dev" "man" ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ linuxHeaders ];

  installTargets = [ "install" "install-man" ];

  doCheck = true;
  separateDebugInfo = true;
  enableParallelBuilding = true;

  patchPhase = ''
    patchShebangs tests
  '';

  # The share/ subdir only contains a doc/ with a README.md that just describes
  # how to compile the library, which clearly isn't very useful! So just get
  # rid of it anyway.
  postInstall = ''
    rm -rf $out/share
  '';

  meta = with lib; {
    description = "Userspace library for the Linux Restartable Sequence API";
    homepage    = "https://github.com/compudj/librseq";
    license     = licenses.lgpl21Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
