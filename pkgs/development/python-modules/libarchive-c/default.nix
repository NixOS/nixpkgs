{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, glibcLocales
, libarchive
, mock
}:

buildPythonPackage rec {
  pname = "libarchive-c";
  version = "2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9919344cec203f5db6596a29b5bc26b07ba9662925a05e24980b84709232ef60";
  };

  checkInputs = [ mock pytest glibcLocales ];

  LC_ALL="en_US.UTF-8";

  postPatch = ''
    substituteInPlace libarchive/ffi.py --replace \
      "find_library('archive')" "'${libarchive.lib}/lib/libarchive${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  checkPhase = ''
    py.test tests -k 'not test_check_archiveentry_with_unicode_entries_and_name_zip and not test_check_archiveentry_using_python_testtar'
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Changaco/python-libarchive-c;
    description = "Python interface to libarchive";
    license = licenses.cc0;
  };

}
