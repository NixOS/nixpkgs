{ stdenv, fetchPypi, buildPythonPackage
, libmediainfo
, setuptools_scm
, pytest }:

buildPythonPackage rec {
  pname = "pymediainfo";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e76cc5525c3fc5cba61073e12365dc06f303b261d8f923aaa6eac09bf8fab245";
  };

  postPatch = ''
    substituteInPlace pymediainfo/__init__.py \
      --replace 'CDLL(library_file)' \
                'CDLL("${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}")' \
      --replace 'CDLL("libmediainfo.0.dylib")' \
                'CDLL("${libmediainfo}/lib/libmediainfo.0${stdenv.hostPlatform.extensions.sharedLibrary}")' \
      --replace 'CDLL("libmediainfo.dylib")' \
                'CDLL("${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}")' \
      --replace 'CDLL("libmediainfo.so.0")' \
                'CDLL("${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}.0")'

    # Fix test, remove after version 2.3.0
    substituteInPlace tests/test_pymediainfo.py \
      --replace 'codec, "AVC"'    'format, "AVC"' \
      --replace 'codec, "AAC LC"' 'format, "AAC"'
  '';

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [  pytest ];

  checkPhase = ''
    py.test -k 'not test_parse_url' tests
  '';

  meta = with stdenv.lib; {
    description = "Python wrapper for the mediainfo library";
    homepage = https://github.com/sbraz/pymediainfo;
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
