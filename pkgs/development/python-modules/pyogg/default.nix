{ stdenv, lib, fetchPypi, buildPythonPackage, libvorbis, flac, libogg, libopus, opusfile }:

buildPythonPackage rec {
    pname = "PyOgg";
    version = "0.6.6a1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1ihzgl8p0rc3yjsp27zdrrs2r4qar5yf5l4v8wg0lilvan78h0rs";
    };

    buildInputs = [ libvorbis flac libogg libopus ];
    propagatedBuidInputs = [ libvorbis flac libogg libopus opusfile ];
    # There are no tests in this package.
    doCheck = false;
    postPatch = ''
      substituteInPlace pyogg/vorbis.py --replace \
        'libvorbisfile = ExternalLibrary.load("vorbisfile")' "libvorbisfile = ctypes.CDLL('${libvorbis}/lib/libvorbisfile${stdenv.hostPlatform.extensions.sharedLibrary}')"
      substituteInPlace pyogg/vorbis.py --replace \
        'libvorbisenc = ExternalLibrary.load("vorbisenc")' "libvorbisenc = ctypes.CDLL('${libvorbis}/lib/libvorbisenc${stdenv.hostPlatform.extensions.sharedLibrary}')"
      substituteInPlace pyogg/vorbis.py --replace \
        'libvorbis = ExternalLibrary.load("vorbis")' "libvorbis = ctypes.CDLL('${libvorbis}/lib/libvorbis${stdenv.hostPlatform.extensions.sharedLibrary}')"
      substituteInPlace pyogg/flac.py --replace \
        'libflac = ExternalLibrary.load("flac")' "libflac = ctypes.CDLL('${flac.out}/lib/libFLAC${stdenv.hostPlatform.extensions.sharedLibrary}')"
      substituteInPlace pyogg/ogg.py --replace \
        'libogg = ExternalLibrary.load("ogg")' "libogg = ctypes.CDLL('${libogg}/lib/libogg${stdenv.hostPlatform.extensions.sharedLibrary}')"
      substituteInPlace pyogg/opus.py --replace \
        'libopus = ExternalLibrary.load("opus")' "libopus = ctypes.CDLL('${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}')"
      substituteInPlace pyogg/opus.py --replace \
        'libopusfile = ExternalLibrary.load("opusfile")' "libopusfile = ctypes.CDLL('${opusfile}/lib/libopusfile${stdenv.hostPlatform.extensions.sharedLibrary}')"
    '';

  meta = {
    description = "Xiph.org's Ogg Vorbis, Opus and FLAC for Python";
    homepage = https://github.com/Zuzu-Typ/PyOgg;
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
}
