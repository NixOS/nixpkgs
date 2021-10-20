{ lib, stdenv, fetchPypi, buildPythonPackage
, libmediainfo
, setuptools-scm
, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "pymediainfo";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d996c69d50081a24d6dca9679abf43ffd2be368b065f953c2c9082e5d649c734";
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

  nativeBuildInputs = [ setuptools-scm ];

  checkInputs = [ glibcLocales pytest ];

  checkPhase = ''
    export LC_ALL=en_US.UTF-8
    py.test -k 'not test_parse_url' tests
  '';

  meta = with lib; {
    description = "Python wrapper for the mediainfo library";
    homepage = "https://github.com/sbraz/pymediainfo";
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
