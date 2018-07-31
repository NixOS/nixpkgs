{ stdenv, fetchPypi, buildPythonPackage
, libmediainfo
, setuptools_scm
, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "pymediainfo";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d0mxxycacimy46b08q44xyxkyji7rrs7viwc3wkpckhqs54q24x";
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
  '';

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ glibcLocales pytest ];

  checkPhase = ''
    export LC_ALL=en_US.UTF-8
    py.test -k 'not test_parse_url' tests
  '';

  meta = with stdenv.lib; {
    description = "Python wrapper for the mediainfo library";
    homepage = https://github.com/sbraz/pymediainfo;
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
