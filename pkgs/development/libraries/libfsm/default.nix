{ stdenv, fetchFromGitHub
, bmake
}:

stdenv.mkDerivation rec {
  pname = "libfsm";
  version = "0.1pre1869_${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner  = "katef";
    repo   = "libfsm";
    rev    = "f70c3c5778a79eeecb52f9fd35c7cbc241db0ed6";
    sha256 = "1hgv272jdv6dwnsdjajyky537z84q0cwzspw9br46qj51h8gkwvx";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ bmake ];
  enableParallelBuilding = true;

  # note: build checks value of '$CC' to add some extra cflags, but we don't
  # necessarily know which 'stdenv' someone chose, so we leave it alone (e.g.
  # if we use stdenv vs clangStdenv, we don't know which, and CC=cc in all
  # cases.) it's unclear exactly what should be done if we want those flags,
  # but the defaults work fine.
  buildPhase = "PREFIX=$out bmake -r install";

  # fix up multi-output install. we also have to fix the pkgconfig libdir
  # file; it uses prefix=$out; libdir=${prefix}/lib, which is wrong in
  # our case; libdir should really be set to the $lib output.
  installPhase = ''
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
