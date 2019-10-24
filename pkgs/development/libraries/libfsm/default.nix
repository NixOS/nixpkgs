{ stdenv, fetchFromGitHub
, bmake
}:

stdenv.mkDerivation rec {
  pname = "libfsm";
  version = "0.1pre1905_${builtins.substring 0 8 src.rev}";

  src = fetchFromGitHub {
    owner  = "katef";
    repo   = pname;
    rev    = "bd5937fad42b26a86bac1fe3ec49eff73581bd1d";
    sha256 = "1q3grbmvjnnvc2sshswbd40cc2j2hnwibmljcqx9jqgda0wd6pgv";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ bmake ];
  enableParallelBuilding = true;

  # note: build checks value of '$CC' to add some extra cflags, but we don't
  # necessarily know which 'stdenv' someone chose, so we leave it alone (e.g.
  # if we use stdenv vs clangStdenv, we don't know which, and CC=cc in all
  # cases.) it's unclear exactly what should be done if we want those flags,
  # but the defaults work fine.
  buildPhase = "PREFIX=$out bmake -r -j$NIX_BUILD_CORES";
  installPhase = ''
    PREFIX=$out bmake -r install
    runHook postInstall
  '';

  # fix up multi-output install. we also have to fix the pkgconfig libdir
  # file; it uses prefix=$out; libdir=${prefix}/lib, which is wrong in
  # our case; libdir should really be set to the $lib output.
  postInstall = ''
    mkdir -p $lib $dev/lib

    mv $out/lib             $lib/lib
    mv $out/include         $dev/include
    mv $out/share/pkgconfig $dev/lib/pkgconfig
    rmdir $out/share

    for x in libfsm.pc libre.pc; do
      substituteInPlace "$dev/lib/pkgconfig/$x" \
        --replace 'libdir=''${prefix}/lib' "libdir=$lib/lib"
    done
  '';

  outputs = [ "out" "lib" "dev" ];

  meta = with stdenv.lib; {
    description = "DFA regular expression library & friends";
    homepage    = "https://github.com/katef/libfsm";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
