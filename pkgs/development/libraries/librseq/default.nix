{ lib, stdenv, fetchFromGitHub
, autoreconfHook, linuxHeaders
}:

stdenv.mkDerivation rec {
  pname = "librseq";
  version = "0.1.0pre71_${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner  = "compudj";
    repo   = "librseq";
    rev    = "170f840b498e1aff068b90188727a656111bfc2f";
    sha256 = "0rdx59y8y9x8cfmmx5gl66gibkzpk3kw5lrrqhrxan8zr37a055y";
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
