{ stdenv, fetchFromBitbucket, makeWrapper
, python3, vapoursynth
, qmake, qtbase, qtwebsockets
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-editor";
  version = "R19";

  src = fetchFromBitbucket {
    owner = "mystery_keeper";
    repo = pname;
    rev = stdenv.lib.toLower version;
    sha256 = "1zlaynkkvizf128ln50yvzz3b764f5a0yryp6993s9fkwa7djb6n";
  };

  nativeBuildInputs = [ qmake makeWrapper ];
  buildInputs = [ qtbase vapoursynth qtwebsockets ];

  preConfigure = "cd pro";

  installPhase = ''
    cd ../build/release*
    mkdir -p $out/bin
    for bin in vsedit{,-job-server{,-watcher}}; do
        mv $bin $out/bin

        wrapProgram $out/bin/$bin \
            --prefix PYTHONPATH : ${vapoursynth}/${python3.sitePackages} \
            --prefix LD_LIBRARY_PATH : ${vapoursynth}/lib
    done
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform editor for VapourSynth scripts";
    homepage = "https://bitbucket.org/mystery_keeper/vapoursynth-editor";
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
