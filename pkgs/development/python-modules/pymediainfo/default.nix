{ stdenv, fetchPypi, buildPythonPackage
, libmediainfo
, setuptools_scm
, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "pymediainfo";
  version = "3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00awypv2nbn44cc38q7w747gx1xhj33cygzzl56jn5jd3hdlldn7";
  };

  postPatch = ''
    substituteInPlace pymediainfo/__init__.py \
      --replace "libmediainfo.0.dylib" \
                "${libmediainfo}/lib/libmediainfo.0${stdenv.hostPlatform.extensions.sharedLibrary}" \
      --replace "libmediainfo.dylib" \
                "${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}" \
      --replace "libmediainfo.so.0" \
                "${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}.0"
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
