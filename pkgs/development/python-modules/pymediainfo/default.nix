{ lib, stdenv, fetchPypi, buildPythonPackage
, libmediainfo
, setuptools_scm
, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "pymediainfo";
  version = "5.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea61a3b0e0ed6de42ebb2233cf1a9312c57dce95101c025f9f081c10ecec48fb";
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

  meta = with lib; {
    description = "Python wrapper for the mediainfo library";
    homepage = "https://github.com/sbraz/pymediainfo";
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
