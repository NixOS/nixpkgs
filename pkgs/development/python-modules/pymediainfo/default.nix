{ stdenv, fetchPypi, buildPythonPackage
, libmediainfo
, setuptools_scm
, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "pymediainfo";
  version = "4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yjs208c34p2xsc0r8vbi264ii5hixh546718n06b7v670glqjir";
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
