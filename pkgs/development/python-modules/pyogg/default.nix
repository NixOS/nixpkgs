{ stdenv, lib, fetchPypi, buildPythonPackage, libvorbis, flac, libogg, libopus, opusfile, substituteAll }:

buildPythonPackage rec {
    pname = "pyogg";
    version = "0.6.9a1";

    src = fetchPypi {
      pname = "PyOgg";
      inherit version;
      sha256 = "0xabqwyknpvfc53s7il5pq6b07fcaqvz5bi5vbs3pbaw8602qvim";
    };

    buildInputs = [ libvorbis flac libogg libopus ];
    propagatedBuidInputs = [ libvorbis flac libogg libopus opusfile ];
    # There are no tests in this package.
    doCheck = false;
    patchFlags = [ "-p1" "--binary" ]; # patch has dos style eol
    patches = [
      (substituteAll {
        src = ./pyogg-paths.patch;
        flacLibPath="${flac.out}/lib/libFLAC${stdenv.hostPlatform.extensions.sharedLibrary}";
        oggLibPath="${libogg}/lib/libogg${stdenv.hostPlatform.extensions.sharedLibrary}";
        vorbisLibPath="${libvorbis}/lib/libvorbis${stdenv.hostPlatform.extensions.sharedLibrary}";
        vorbisFileLibPath="${libvorbis}/lib/libvorbisfile${stdenv.hostPlatform.extensions.sharedLibrary}";
        vorbisEncLibPath="${libvorbis}/lib/libvorbisenc${stdenv.hostPlatform.extensions.sharedLibrary}";
        opusLibPath="${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}";
        opusFileLibPath="${opusfile}/lib/libopusfile${stdenv.hostPlatform.extensions.sharedLibrary}";
      })
    ];

  meta = {
    description = "Xiph.org's Ogg Vorbis, Opus and FLAC for Python";
    homepage = "https://github.com/Zuzu-Typ/PyOgg";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
}
